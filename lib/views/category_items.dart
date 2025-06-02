import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/category_model.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/views/detail_screen.dart';
import 'package:flutter/material.dart';

class CategoryItems extends StatelessWidget {
  final String category;
  final List<Products> categoryItems;
  final List<Categories> subcategory;

  const CategoryItems({
    super.key,
    required this.category,
    required this.categoryItems,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: category,
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: bannerColor,
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          prefixIcon: const Icon(Icons.search, color: Colors.black),
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Subcategory scroll
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subcategory.length,
                itemBuilder: (context, index) {
                  final cat = subcategory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(ApiPath.Image + (cat.imageUrl ?? '')),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cat.categoryName ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Product Grid
            Expanded(
              child: categoryItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No items available in this category",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categoryItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final item = categoryItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(eCommerceApp: item),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: item.id ?? item.imageUrl ?? index.toString(),
                                child: Container(
                                  height: size.height * 0.25,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(ApiPath.Image + item.imageUrl.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              SizedBox(
                                width: size.width * 0.5,
                                child: Text(
                                  item.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.5,
                                child: Text(
                                  item.description ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₭ ${item.price?.toStringAsFixed(2) ?? '0.00'}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  if (item.isCheck == true)
                                    Text(
                                      "₭ ${(item.price ?? 0) + 100000}.00",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
