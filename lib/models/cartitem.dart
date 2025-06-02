class CartItem {
  final String name;
  int quantity;
  final double price;

  CartItem({
    required this.name,
    this.quantity = 1,
    required this.price,
  });
}
