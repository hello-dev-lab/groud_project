import 'package:firstapp/Widgets/curated_item.dart';
import 'package:firstapp/models/fashion.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/Widgets/banner.dart';
import 'package:firstapp/views/category_items.dart';
import 'package:firstapp/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Column(
          children: [
            Expanded(
              // ทำให้ Column เต็มหน้าจอ
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              "images/kingpng.png",
                              height: 60,
                              width: 60,
                            ),
                          ),

                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              Positioned(
                                right: -3,
                                top: -5,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "3",
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
                        ],
                      ),
                    ),

                    //for banner
                    const MyBanner(),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ເລືອກຊື້ຕາມໝວດໝູ່",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "ເພີ່ມເຕີມ",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // for category
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          subcategory.length,
                          (index) => InkWell(
                            onTap: () {
                              final filterItem =
                                  fashionEcommerceApp
                                      .where(
                                        (item) =>
                                            item.category.toLowerCase() ==
                                            subcategory[index].name
                                                .toLowerCase(),
                                      )
                                      .toList();
                              // navigate to the category items screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CategoryItems(
                                        category: subcategory[index].name,
                                        categoryItems: filterItem,
                                      ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      subcategory[index].images,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  subcategory[index].name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ເລືອກຊື້ຕາມໝວດໝູ່",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "ເພີ່ມເຕີມ",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // for curated items
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(fashionEcommerceApp.length, (
                          index,
                        ) {
                          final eCommerceItems = fashionEcommerceApp[index];
                          return Padding(
                            padding:
                                index == 0
                                    ? const EdgeInsets.symmetric(horizontal: 20)
                                    : const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailScreen(
                                          eCommerceApp: eCommerceItems,
                                        ),
                                  ),
                                );
                              },
                              child: CuratedItem(
                                eCommerceItems: eCommerceItems,
                                size: size,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
