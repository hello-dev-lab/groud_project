import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:firstapp/utils/CartProvider.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/models/cartitem.dart';
import 'package:firstapp/views/cart_screen.dart';
import 'package:provider/provider.dart';

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
        title: const Text("ລາຍລະອຽດສິນຄ້າ", style: TextStyle(color: Colors.white)),
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
                icon: const Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen(cartItems: [])),
                  );
                },
              ),
              if (cartProvider.items.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
              child: PageView.builder(
                onPageChanged: (value) => setState(() => currentIndex = value),
                itemCount: 3, // เปลี่ยนตามจำนวนภาพจริงหากมีหลายภาพ
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Hero(
                        tag: widget.eCommerceApp.id.toString(), // ✅ สำคัญ: ต้องตรงกับ Hero ในหน้าแรก
                        child: Image.network(
                          ApiPath.Image + widget.eCommerceApp.imageUrl.toString(),
                          height: size.height * 0.4,
                          width: size.width * 0.85,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 4),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == currentIndex ? Colors.blue : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "₭ ${widget.eCommerceApp.price?.toStringAsFixed(2) ?? '0.00'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.eCommerceApp.isCheck == true)
                        Text(
                          "₭ ${widget.eCommerceApp.originalPrice?.toStringAsFixed(2) ?? '0.00'}",
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.eCommerceApp.description ?? "No description",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 20),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final item = CartItem(
                    name: widget.eCommerceApp.name ?? "No name",
                    quantity: 1,
                    price: widget.eCommerceApp.price?.toDouble() ?? 0.0,
                  );
                  cartProvider.addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} ຖືກເພີ່ມໃສ່ກະຕ່າແລ້ວ'),
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  cartProvider.addItem(CartItem(
                    name: widget.eCommerceApp.name ?? "No name",
                    quantity: 1,
                    price: widget.eCommerceApp.price?.toDouble() ?? 0.0,
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen(cartItems: [])),
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
