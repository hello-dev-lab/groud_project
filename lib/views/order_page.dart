import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firstapp/models/cartitem.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstapp/models/Districts.dart';
import 'package:firstapp/models/Provinces.dart';
import 'package:firstapp/views/main_screen.dart';
import 'package:firstapp/utils/CartProvider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderPage extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const OrderPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedTransportation;
  String? selectedPayment;
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final List<String> transportations = ['ອະນຸສິດ', 'ຮຸ່ງອາລຸນ'];
  final List<String> items = ['ຕົ້ນທາງ', 'ປາຍທາງ'];

  // File? _selectedImage;

  // final ImagePicker _picker = ImagePicker();

  XFile? imgFile;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      imgFile = picked;
    });
  }

 Future<String?> uploadImage(XFile imageFile) async {
  try {
    final uri = Uri.parse(ApiPath.baseUrl + 'upload/upload-single-file');
    var request = http.MultipartRequest('POST', uri);

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file', // ✅ Corrected field name
        bytes,
        filename: imageFile.name,
      );
      request.files.add(multipartFile);
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // ✅ Corrected field name
          imageFile.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['fileName']; 
    } else {
      print("Image upload failed with ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error uploading image: $e");
    return null;
  }
}

  Future<void> _SaveOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProvince == null ||
        selectedDistrict == null ||
        selectedTransportation == null ||
        selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = await storage.read(key: 'token');

      // Optional image upload
      String? imageUrl;
      if (imgFile != null) {
        imageUrl = await uploadImage(imgFile!);
      }

      final orderData = {
        'province': selectedProvince,
        'district': selectedDistrict,
        'village': _villageController.text,
        'phoneNumber': _phoneController.text,
        'Transportation': selectedTransportation,
        'total_amount': widget.totalAmount,
        'payment_method': selectedPayment,
        'payment_image': imageUrl,
      };

      final response = await http.post(
        Uri.parse(ApiPath.baseUrl + 'order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final orderId = responseData['order']['id'];
        await saveOrderDetail(order_id: orderId.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully.')),
        );
      } else {
        print(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to place order.')));
      }
    } catch (e) {
      print('Error saving order: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred.')));
    }

    setState(() => isLoading = false);
  }

  Future<void> saveOrderDetail({required String order_id}) async {
    try {
      for (var item in widget.cartItems) {
        var response = await http.post(
          Uri.parse(ApiPath.baseUrl + 'orderDetail'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'order_id': order_id,
            'product_id': item.productId,
            'quantity': item.quantity,
            'price': item.quantity * item.price,
          }),
        );

        if (response.statusCode != 201) {
          print('Failed to save order detail: ${response.body}');
        }
      }

      // ✅ Clear cart from provider
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Exception saving order detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save order details.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 70, 70),
      appBar: AppBar(
        title: const Text('Order Page', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Align(
                child: Text(
                  'ຂໍ້ມູນທີ່ຢູ່',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              _buildDropdown('ແຂວງ', laoProvinces, selectedProvince, (val) {
                setState(() {
                  selectedProvince = val;
                  selectedDistrict = null;
                });
              }),
              const SizedBox(height: 10),
              _buildDropdown(
                'ເມືອງ',
                Districts.data[selectedProvince] ?? [],
                selectedDistrict,
                (val) => setState(() => selectedDistrict = val),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _villageController,
                decoration: InputDecoration(
                  hintText: 'ບ້ານ',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'ກະລຸນາໃສ່ບ້ານ'
                            : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'ເບີໂທ',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'ກະລຸນາໃສ່ເບີໂທ'
                            : null,
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                'ຂົນສົ່ງ',
                transportations,
                selectedTransportation,
                (val) => setState(() => selectedTransportation = val),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                'ການຊໍາລະເງິນ',
                items,
                selectedPayment,
                (val) => setState(() => selectedPayment = val),
              ),
              const SizedBox(height: 20),
              if (selectedPayment == 'ຕົ້ນທາງ')
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '23456789',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Better-looking image container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIImDqGJY4IoIHr5mroIuqvSjwf2RJBq9Z8g&s', // keep your full base64 here
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ຮູບພາບການຊໍາລະ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: Icon(Icons.folder),
                              label: Text("Pick Image"),
                            ),
                            const SizedBox(height: 20),
                            imgFile != null
                                ? kIsWeb
                                    ? Image.network(
                                      imgFile!.path,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.file(
                                      File(imgFile!.path),
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                : Text("No image selected."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "You're Buying",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              // Fixed: provide unique key to each item
              ...widget.cartItems.asMap().entries.map((entry) {
                int index = entry.key;
                CartItem item = entry.value;
                return KeyedSubtree(
                  key: ValueKey("cart_item_${item.productId}_$index"),
                  child: _buildProductItem(item),
                );
              }).toList(),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "TOTAL: ${widget.totalAmount.toStringAsFixed(2)} ₭",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: MaterialButton(
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Order Now',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  onPressed: isLoading ? null : _SaveOrder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        underline: const SizedBox(),
        hint: Text(hint),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildProductItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Scaffold(
                        body: Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                imageProvider: NetworkImage(
                                  ApiPath.Image + (item.imageUrl ?? ''),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 20,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              );
            },
            child: Image.network(
              ApiPath.Image + (item.imageUrl ?? ''),
              width: 60,
              height: 60,
              errorBuilder:
                  (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Price: ₭ ${item.price}"),
                Text("Qty: ${item.quantity}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
