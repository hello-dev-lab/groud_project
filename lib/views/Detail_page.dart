import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final int orderDetailId;

  const DetailPage({super.key, required this.orderDetailId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? orderDetail;
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    _loadFakeOrderDetail(); // use mock data
  }

  // Simulate loading fake data (replace this with real API later)
  void _loadFakeOrderDetail() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading delay
    setState(() {
      orderDetail = {
        "order_id": 12345,
        "product_id": 67890,
        "quantity": 2,
        "price": "25000",
        "user_id": "user_abc123",
        "payment_method": "VISA",
        "amount": "50000",
        "payment_date": "2025-07-07"
      };
      isLoading = false;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 5,
            child: Text(
              ": $value",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("🧾 Order Detail"),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildInfoRow("Order ID", orderDetail!['order_id']),
                          _buildInfoRow("Product ID", orderDetail!['product_id']),
                          _buildInfoRow("Quantity", orderDetail!['quantity']),
                          _buildInfoRow("Price (₭)", orderDetail!['price']),
                        ],
                      ),
                    ),
                  ),
                  _buildSectionTitle("💳 Payment Info"),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildInfoRow("User ID", orderDetail!['user_id']),
                          _buildInfoRow("Payment Method", orderDetail!['payment_method']),
                          _buildInfoRow("Amount (₭)", orderDetail!['amount']),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[900],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back to Home"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
