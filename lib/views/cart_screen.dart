import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/cartitem.dart';
import 'package:firstapp/views/order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/CartProvider.dart';
import '../utils/color.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.items;

    double calculateTotal() {
      return cart.fold(0, (sum, item) => sum + item.price * item.quantity);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🛒 ກະຕ່າຂອງຂ້ອຍ",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          cart.isEmpty
              ? const Center(
                child: Text(
                  "🛒ບໍ່ມີສິນຄ້າໃນກະຕ່າ",
                  style: TextStyle(fontSize: 18),
                ),
              )
              : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        (item.imageUrl ?? '').isNotEmpty
                                            ? Image.network(
                                              ApiPath.Image +
                                                  item.imageUrl.toString(),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                            )
                                            : const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "ລາຄາ: ₭ ${item.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "ຈໍານວນ: ${item.quantity}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed:
                                            () => cartProvider.addItem(item),
                                        icon: Icon(Icons.add),
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => cartProvider.removeItem(item),
                                        icon: Icon(Icons.remove),
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  cartProvider.deleteItem(item);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ];
                                        },
                                        icon: Icon(Icons.more_vert),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: const Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ລວມທັງໝົດ:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "₭ ${calculateTotal().toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.shopping_cart_checkout),
                                label: const Text("ສັ່ງຊື້"),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("ຂອບໃຈສຳລັບການສັ່ງຊື້!"),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => OrderPage(
                                            totalAmount: calculateTotal(),
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
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
