import 'package:firstapp/models/cartitem.dart';

class CartManager {
  static final List<CartItem> _cartItems = [];

  static void addToCart(CartItem item) {
    // ตรวจสอบว่ามีสินค้านี้อยู่แล้วหรือยัง
    final existingIndex = _cartItems.indexWhere(
      (element) =>
          element.name == item.name &&
          element.price == item.price,
    );

    if (existingIndex >= 0) {
      // ถ้ามีแล้ว -> เพิ่มจำนวน
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = CartItem(
        name: existingItem.name,
        quantity: existingItem.quantity + item.quantity,
        price: existingItem.price,
        imageUrl: existingItem.imageUrl, productId: '',
      );
    } else {
      // ถ้ายังไม่มี -> เพิ่มใหม่
      _cartItems.add(item);
    }
  }

  static List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  static int get itemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  static double get total =>
      _cartItems.fold(0, (sum, item) => sum + (item.quantity * item.price));

  static void clearCart() {
    _cartItems.clear();
  }

  static void removeFromCart(CartItem item) {
    _cartItems.removeWhere((element) =>
        element.name == item.name && element.price == item.price);
  }
}
