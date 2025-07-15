class CartItem {
  final String productId; // <== Add this!
  final String name;
  int quantity;
  final double price;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    this.quantity = 1,
    required this.price,
    required this.imageUrl,
  });
}
