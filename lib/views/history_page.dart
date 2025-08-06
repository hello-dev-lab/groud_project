import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firstapp/models/order_model.dart';
import 'package:firstapp/models/orderDetail_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Order> orders = [];
  List<OrderDetail> orderDetails = [];
  bool isLoading = true;
  String errorMsg = '';

  // Use FlutterSecureStorage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final url = "${ApiPath.baseUrl}my-orders";

    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    try {
      final token = await secureStorage.read(key: 'token');

      if (token == null) {
        setState(() {
          errorMsg = 'Token not found. Please log in again.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final orderModel = OrderModel.fromJson(jsonResponse);

        setState(() {
          orders = orderModel.orders;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Failed to load orders: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<List<OrderDetail>> fetchOrderDetails(int orderId) async {
    try {
      final token = await secureStorage.read(key: 'token');
      final url = '${ApiPath.baseUrl}orderDetail/getOrder/$orderId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> detailsJson = jsonData['orderDetails'];
        return detailsJson.map((e) => OrderDetail.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load order details");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Helper for displaying enums
  String enumToString(Object? enumValue) {
    if (enumValue == null) return '';
    return enumValue.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMsg.isNotEmpty
                ? Center(child: Text(errorMsg))
                : orders.isEmpty
                ? const Center(child: Text('No orders found'))
                : ListView.builder(
                  itemCount: orders.length,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final formattedDate =
                        order.orderDate.toLocal().toString().split(' ')[0];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          '📅 Date: $formattedDate',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Province: ${order.province}'),
                            Text('District: ${order.district}'),
                            Text('Village: ${order.village}'),
                            Text('Phone: ${order.phoneNumber}'),
                            const SizedBox(height: 6),
                            Text(
                              'Status: ${enumToString(order.status)}',
                              style: TextStyle(
                                color:
                                    order.status == Status.DELIVERED
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: ₭ ${order.totalAmount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FutureBuilder<List<OrderDetail>>(
                                future: fetchOrderDetails(order.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: Text(snapshot.error.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  } else {
                                    final orderDetailList = snapshot.data ?? [];

                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '🛒 Products in Order',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              ...orderDetailList.map((detail) {
                                                final product =
                                                    detail.tbProduct;
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      leading: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (_) => Dialog(
                                                                  child: PhotoView(
                                                                    imageProvider: NetworkImage(
                                                                      ApiPath.Image +
                                                                          product
                                                                              .imageUrl,
                                                                    ),
                                                                    backgroundDecoration:
                                                                        BoxDecoration(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                  ),
                                                                ),
                                                          );
                                                        },
                                                        child: Image.network(
                                                          ApiPath.Image +
                                                              product.imageUrl,
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      title: Text(product.name),
                                                      subtitle: Text(
                                                        'Qty: ${detail.quantity} × ₭${detail.price}',
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                );
                                              }).toList(),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  icon: const Icon(Icons.close),
                                                  label: const Text("Close"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.brown,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
