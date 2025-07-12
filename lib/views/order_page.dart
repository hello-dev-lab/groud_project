// order_page.dart
import 'dart:convert';

import 'package:firstapp/models/cartitem.dart';
import 'package:firstapp/views/Detail_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/Districts.dart';
import 'package:firstapp/models/Provinces.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

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
  String? selectedVillage;
  final storage = const FlutterSecureStorage();
  bool isLoading = false;

  final List<String> villages = ['Village A', 'Village B'];

  _SaveOrder() async {
    setState(() {
      isLoading = true;
    });

    // Validation
    if (selectedProvince == null ||
        selectedDistrict == null ||
        selectedVillage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select all fields.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var token = await storage.read(key: 'token');

      final orderData = {
        'province': selectedProvince,
        'district': selectedDistrict,
        'village': selectedVillage,
        'total_amount': widget.totalAmount,
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
        print("Response data: $responseData");

        final orderId = responseData['id'];
        await saveOrderDetail(order_id: orderId.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully.')),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailPage(orderDetailId: orderId),
        //   ),
        // );
      } else {
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

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveOrderDetail({required String order_id}) async {
    try {
      for (var item in widget.cartItems) {
        print(
          "Sending order detail: order_id=$order_id, product_id=${item.productId}, quantity=${item.quantity}, price=${item.price}",
        );

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
          child: Column(
            children: [
              _buildDropdown('ແຂວງ', laoProvinces, selectedProvince, (val) {
                setState(() {
                  selectedProvince = val;
                  selectedDistrict = null;
                  selectedVillage = null;
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
              _buildDropdown(
                'ບ້ານ',
                villages,
                selectedVillage,
                (val) => setState(() => selectedVillage = val),
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

              // List of items from cart
              ...widget.cartItems.map(_buildProductItem).toList(),

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

  // Dropdown widget builder
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

  // Product cart item UI
  Widget _buildProductItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            child: GestureDetector(
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
                                  child: Icon(Icons.close, color: Colors.white),
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
