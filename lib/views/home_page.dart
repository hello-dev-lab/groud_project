import 'dart:convert';

import 'package:firstapp/Widgets/curated_item.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/category_model.dart';
import 'package:firstapp/models/fashion.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/Widgets/banner.dart';
import 'package:firstapp/views/category_items.dart';
import 'package:firstapp/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Data> subcategory = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(ApiPath.CATEGORY));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> dataList = jsonData['data'];

      subcategory = dataList.map<Data>((json) => Data.fromJson(json)).toList();

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load categories: ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Column(
          children: [
            Expanded(
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

                    const MyBanner(),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
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

                    isLoading
                        ? CircularProgressIndicator()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                subcategory.length,
                                (index) => InkWell(
                                  onTap: () {
                                    final filterItem = fashionEcommerceApp
                                        .where((item) => item.category.toLowerCase() ==
                                            subcategory[index].categoryName.toLowerCase())
                                        .toList();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryItems(
                                          category: subcategory[index].categoryName,
                                          categoryItems: filterItem, subcategory: [],
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
                                          backgroundImage:
                                              NetworkImage(subcategory[index].imageUrl),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        subcategory[index].categoryName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(fashionEcommerceApp.length, (index) {
                          final eCommerceItems = fashionEcommerceApp[index];
                          return Padding(
                            padding: index == 0
                                ? const EdgeInsets.symmetric(horizontal: 20)
                                : const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(
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