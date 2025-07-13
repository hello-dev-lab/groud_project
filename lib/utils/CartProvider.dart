import 'package:flutter/foundation.dart';
import 'package:firstapp/models/cartitem.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  get cartItems => null;

  void addItem(CartItem newItem) {
    final index = _items.indexWhere(
      (item) => item.name == newItem.name && item.price == newItem.price,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(newItem);
    }

    notifyListeners();
  }

  void removeItem(CartItem item) {
    final index = _items.indexWhere(
      (element) => element.name == item.name && element.price == item.price,
    );

    if (index >= 0) {
      if(_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        return;
      }
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void deleteItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void addToCart(eCommerceApp) {}
}
