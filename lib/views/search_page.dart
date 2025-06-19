import 'dart:convert';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:firstapp/utils/CartProvider.dart';
import 'package:firstapp/views/cart_screen.dart';
import 'package:firstapp/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/utils/color.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Products> products = [];
  List<Products> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _searchController.addListener(_search);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchProducts() async {
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
          filteredProducts = products; // Initially show all
        });
      } else {
        print("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _search() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final name = product.name?.toLowerCase() ?? '';
        return name.contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset("images/kingpng.png", height: 60, width: 60),
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
      builder: (_) => const CartScreen(), 
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
                                    child: Center(
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
                                ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white60),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Products
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                      ? Text("No products found", style: TextStyle(color: Colors.white))
                      : GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: List.generate(filteredProducts.length, (index) {
                            final product = filteredProducts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),child:  InkWell(
                                onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailScreen(
                                          eCommerceApp: product,
                                        ),
                                  ),
                                );
                              },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppGradients.customGradient.colors[0],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: NetworkImage(ApiPath.Image + (product.imageUrl ?? '')),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Colors.white,
                                                child: Icon(Icons.favorite_border, color: Colors.pink),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          product.name ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            height: 1.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          product.description ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            height: 1.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "₭${product.price ?? ''}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            height: 1.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
