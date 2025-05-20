import 'package:flutter/material.dart';
import '../models/cartitem.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cartItems); // สร้างสำเนาเพื่อแก้ไขได้
  }

  void _removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: _cart.isEmpty
          ? Center(child: Text("ไม่มีสินค้าในตะกร้า"))
          : ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("จำนวน: ${item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("₭ ${(item.quantity * item.price).toStringAsFixed(2)}"),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
