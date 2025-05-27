class CategoryModel {
  final String message;
  final Data data;

  CategoryModel({
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String id;
  final String categoryName;
  final String imageUrl;
  final DateTime updatedAt;
  final DateTime createdAt;

  Data({
    required this.id,
    required this.categoryName,
    required this.imageUrl,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      categoryName: json['categoryName'],
      imageUrl: json['imageUrl'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
