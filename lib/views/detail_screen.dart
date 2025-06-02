import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/models/cartitem.dart';
import 'package:firstapp/views/cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Products eCommerceApp;
  const DetailScreen({Key? key, required this.eCommerceApp}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<CartItem> _localCart = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Product",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cartItems: _localCart),
                    ),
                  );
                },
              ),
              if (_localCart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      _localCart.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 20),
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
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Hero(
                        tag: widget.eCommerceApp.imageUrl.toString(),
                        child: Image.network(
                          ApiPath.Image + (widget.eCommerceApp.imageUrl.toString()),
                          height: size.height * 0.4,
                          width: size.width * 0.85,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                      SizedBox(height: 15),
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
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eCommerceApp.name ?? "No name",
                    maxLines: 1,
                    style: TextStyle(
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
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.eCommerceApp.isCheck == true)
                        Text(
                          "₭ ${widget.eCommerceApp.originalPrice.toString()}.00",
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    widget.eCommerceApp.description ?? "No description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                      letterSpacing: -.5,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  widget.eCommerceApp.imageUrl.toString().length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ApiPath.Image + (widget.eCommerceApp.imageUrl.toString()),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
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
                  final selectedProduct = widget.eCommerceApp;

                  final item = CartItem(
                    name: selectedProduct.name.toString(),
                    quantity: 1,
                    price: selectedProduct.price ?? 0.0,
                  );

                  setState(() {
                    final existingIndex = _localCart.indexWhere(
                      (e) => e.name == item.name && e.price == item.price,
                    );

                    if (existingIndex >= 0) {
                      final existingItem = _localCart[existingIndex];
                      _localCart[existingIndex] = CartItem(
                        name: existingItem.name,
                        quantity: existingItem.quantity + 1,
                        price: existingItem.price,
                      );
                    } else {
                      _localCart.add(item);
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${selectedProduct.name} ถูกเพิ่มไปยังตะกร้าแล้ว'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppGradients.customGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "ADD TO CART",
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
            SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print("Buy now");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "BUY NOW",
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
