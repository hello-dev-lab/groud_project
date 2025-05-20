import 'package:firstapp/models/fashion.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/models/cartitem.dart';
import 'package:firstapp/views/cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final AppModel eCommerceApp;
  const DetailScreen({super.key, required this.eCommerceApp});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<CartItem> _localCart = [];

  int currentIndex = 0;
  int selectedColorIndex = 1;
  int selectedSizeIndex = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Product",
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // ใช้ในการย้อนกลับ
          },
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color: Colors.white,
                ),
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
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _localCart.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Hero(
                        tag: widget.eCommerceApp.image,
                        child: Image.asset(
                          widget.eCommerceApp.image,
                          height: size.height * 0.4,
                          width: size.width * 0.85,
                          fit: BoxFit.cover,
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
                              color:
                                  index == currentIndex
                                      ? Colors.blue
                                      : Colors.grey.shade400,
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
                  Row(
                    children: [
                      Text(
                        "Digital Mart ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.star, color: Colors.amber, size: 17),
                      Text(
                        widget.eCommerceApp.rating.toString(),
                        style: const TextStyle(color: Colors.amber),
                      ),
                      Text(
                        "(${widget.eCommerceApp.rewiews})",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Icon(Icons.share, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    widget.eCommerceApp.name,
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
                        "₭ ${widget.eCommerceApp.prince.toString()}.00",
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
                          "₭ ${widget.eCommerceApp.prince + 100000}.00",
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
                    widget.eCommerceApp.description.isNotEmpty
                        ? widget.eCommerceApp.description
                        : "ບໍ່ມີຄຳອະທີບາຍຂອງສິນຄ້າ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                      letterSpacing: -.5,
                    ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width / 2.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Color",
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    widget.eCommerceApp.fcolors
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final color = entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                            ),
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundColor: color,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedColorIndex = index;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.check,
                                                  color:
                                                      selectedColorIndex ==
                                                              index
                                                          ? Colors.black
                                                          : Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // size
                      // SizedBox(
                      //   width: size.width / 2.3,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Zize",
                      //         style: TextStyle(
                      //           color: Colors.white38,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children:
                      //               widget.eCommerceApp.size
                      //                   .asMap()
                      //                   .entries
                      //                   .map((entry) {
                      //                     final index = entry.key;
                      //                     final String size = entry.value;
                      //                     return GestureDetector(
                      //                       onTap: () {
                      //                         setState(() {
                      //                           selectedSizeIndex = index;
                      //                         });
                      //                       },
                      //                       child: Container(
                      //                         margin: const EdgeInsets.only(
                      //                           right: 10,
                      //                           top: 10,
                      //                         ),
                      //                         height: 35,
                      //                         width: 35,
                      //                         decoration: BoxDecoration(
                      //                           shape: BoxShape.circle,
                      //                           color:
                      //                               selectedSizeIndex == index
                      //                                   ? Colors.black
                      //                                   : Colors.white,
                      //                           border: Border.all(
                      //                             color:
                      //                                 selectedSizeIndex == index
                      //                                     ? Colors.white
                      //                                     : Colors.black,
                      //                           ),
                      //                         ),
                      //                         child: Center(
                      //                           child: Text(
                      //                             size,
                      //                             style: TextStyle(
                      //                               fontWeight: FontWeight.bold,
                      //                               color:
                      //                                   selectedSizeIndex ==
                      //                                           index
                      //                                       ? Colors.white
                      //                                       : Colors.black,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     );
                      //                   })
                      //                   .toList(),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white, // หรือใช้ gradient ถ้าต้องการ
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        height: 70, // ⭐ เพิ่มความสูงชัดเจนเพื่อไม่ให้ยืดผิดแนว
        child: Row(
          children: [
            // ADD TO CART
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final selectedProduct = widget.eCommerceApp;

                  final item = CartItem(
                    name: selectedProduct.name,
                    quantity: 1,
                    price: selectedProduct.prince.toDouble(),
                  );

                  setState(() {
                    // ตรวจสอบว่ามีใน cart แล้วหรือยัง
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
                      content: Text(
                        '${selectedProduct.name} ถูกเพิ่มไปยังตะกร้าแล้ว',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ),
                  );

                  print("Current local cart: ${_localCart.length} items");
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

            // BUY NOW
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print("Buy now");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green, // ลองใช้สีตรงๆ เพื่อดูชัดเจน
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
