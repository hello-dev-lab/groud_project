import 'package:carousel_slider/carousel_slider.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      'images/laptop.png',
      'images/computer-mouse.png',
      'images/keyboard_computer.webp',
    ];

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: size.width,
      color: bannerColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            // Left-aligned Promo Text & Button
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "NEW COLLECTION",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      color: Colors.black,
                    ),
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "20",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "%",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "OFF",
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: -1,
                              fontWeight: FontWeight.bold,
                              height: 0.8,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MaterialButton(
                    onPressed: () {
                      // TODO: Add navigation or action
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "SHOP NOW",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Right-aligned Carousel
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: size.width * 0.45,
                height: size.height * 0.22,
                child: CarouselSlider(
                  items: imageList.map((imagePath) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: size.height * 0.22,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 1.5,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
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
