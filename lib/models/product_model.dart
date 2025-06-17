class Productsmodel {
  String? message;
  List<Products>? products;

  Productsmodel({this.message, this.products});

  Productsmodel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['products'] != null) {
      products = <Products>[];
      for (var item in json['products']) {
        products!.add(Products.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = this.message;
    if (this.products != null) {
      data['products'] = this.products!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? imageUrl;
  double? price;
  int? originalPrice;
  String? description;
  String? category;
  String? createdAt;
  String? updatedAt;
  final bool isCheck;

  Products({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.originalPrice,
    this.description,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.isCheck = false,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      price: (json['price'] as num?)?.toDouble(),
      originalPrice: json['original_price'],
      description: json['description'],
      category: json['category'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  get colors => null;

  get categoryId => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['price'] = this.price;
    data['original_price'] = this.originalPrice;
    data['description'] = this.description;
    data['category'] = this.category;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
