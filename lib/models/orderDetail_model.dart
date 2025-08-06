class OrderDetail {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final String price;
  final TbProduct tbProduct;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.tbProduct,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['orderId'] ?? json['order_id'],
      productId: json['productId'] ?? json['product_id'],
      quantity: json['quantity'],
      price: json['price']?.toString() ?? '',
      tbProduct: json['tbProduct'] != null
          ? TbProduct.fromJson(json['tbProduct'])
          : (json['tb_product'] != null
              ? TbProduct.fromJson(json['tb_product'])
              : TbProduct(
                  id: 0,
                  name: 'Unknown',
                  price: 0,
                  imageUrl: '',
                  description: 'No product info',
                )),
    );
  }
}

class TbProduct {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final String description;

  TbProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory TbProduct.fromJson(Map<String, dynamic> json) {
    return TbProduct(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
