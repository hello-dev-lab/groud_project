import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../api/api_path.dart';
import '../models/product_model.dart';
import '../models/cartitem.dart';
import '../utils/CartProvider.dart';
import '../utils/color.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Products eCommerceApp;
  const DetailScreen({Key? key, required this.eCommerceApp}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ລາຍລະອຽດສິນຄ້າ",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: ListView(
          children: [
            Container(
              color: Colors.grey.shade200,
              height: size.height * 0.46,
              width: size.width,
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
                                      ApiPath.Image +
                                          widget.eCommerceApp.imageUrl
                                              .toString(),
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
                child: Hero(
                  tag: 'product-${widget.eCommerceApp.id}',
                  child: Image.network(
                    ApiPath.Image + widget.eCommerceApp.imageUrl.toString(),
                    height: size.height * 0.4,
                    width: size.width * 0.85,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eCommerceApp.name ?? "No name",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "₭ ${widget.eCommerceApp.price?.toStringAsFixed(2) ?? '000'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10,),
                     Text('₭${widget.eCommerceApp.originalPrice.toString()}.000', style: TextStyle(color: Colors.white),)
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.eCommerceApp.description ?? "No description",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cartProvider.addItem(
                    CartItem(
                      name: widget.eCommerceApp.name ?? "No name",
                      quantity: 1,
                      price: widget.eCommerceApp.price?.toDouble() ?? 0.0,
                      imageUrl: widget.eCommerceApp.imageUrl ?? "", productId: '',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.eCommerceApp.name} ຖືກເພີ່ມໃສ່ກະຕ່າແລ້ວ',
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppGradients.customGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "ເພີ່ມໃສ່ກະຕ່າ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  cartProvider.addItem(
                    CartItem(
                      name: widget.eCommerceApp.name ?? "No name",
                      quantity: 1,
                      price: widget.eCommerceApp.price?.toDouble() ?? 0.0,
                      imageUrl: widget.eCommerceApp.imageUrl ?? "", productId: '',
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "ຊື້ຕອນນີ້",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
