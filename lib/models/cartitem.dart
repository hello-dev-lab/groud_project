class CartItem {
  final String name;
  int quantity;
  final double price;
  final String? imageUrl;

  CartItem({
    required this.name,
    this.quantity = 1,
    required this.price,
    required this.imageUrl,
  });

  get id => null;
}
