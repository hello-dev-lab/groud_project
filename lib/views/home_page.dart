import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/Widgets/banner.dart';
import 'package:firstapp/views/cart_screen.dart';
import 'package:firstapp/utils/CartProvider.dart';
import 'package:firstapp/views/detail_screen.dart';
import 'package:firstapp/Widgets/curated_item.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:firstapp/views/category_items.dart';
import 'package:firstapp/models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Categories> subcategory = [];
  List<Products> products = [];
  bool isLoading = false;

  void fetchCategory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(ApiPath.CATEGORY));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final categoryData = categorymodel.fromJson(jsonResponse);
        setState(() {
          subcategory = categoryData.categories ?? [];
        });
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void fetchProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(ApiPath.PRODUCT));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final productData = Productsmodel.fromJson(jsonResponse);
        setState(() {
          products = productData.products ?? [];
        });
      } else {
        print("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print('Product fetch error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategory();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "images/kingpng.png",
                            height: 60,
                            width: 60,
                          ),
                          Stack(
                            clipBehavior: Clip.none,
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
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ),
                              if (cart.itemCount > 0)
                                Positioned(
                                  right: -3,
                                  top: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      cart.itemCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                     Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories".tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "more".tr,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                subcategory.map((cat) {
                                  final filteredItems =
                                      products
                                          .where(
                                            (item) =>
                                                item.category?.toLowerCase() ==
                                                cat.categoryName?.toLowerCase(),
                                          )
                                          .toList();

                                  return InkWell(
                                    onTap: () {
                                      final filteredItems =
                                          products
                                              .where(
                                                (item) =>
                                                    item.category
                                                        ?.toLowerCase()
                                                        .trim() ==
                                                    cat.categoryName
                                                        ?.toLowerCase()
                                                        .trim(),
                                              )
                                              .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => CategoryItems(
                                                category:
                                                    cat.categoryName ?? '',
                                                categoryItems: filteredItems,
                                                subcategory: subcategory,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              ApiPath.Image +
                                                  (cat.imageUrl ?? ''),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          cat.categoryName ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                     Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose to buy by category".tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "more".tr,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(products.length, (index) {
                          final eCommerceItems = products[index];
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
