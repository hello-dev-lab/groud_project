class OrderModel {
  String message;
  List<Order> orders;

  OrderModel({
    required this.message,
    required this.orders,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    message: json['message'] ?? '',
    orders: (json['orders'] as List<dynamic>? ?? [])
        .map((e) => Order.fromJson(e))
        .toList(),
  );
}

class Order {
  int id;
  int userId;
  String province;
  String district;
  String village;
  int totalAmount;
  String phoneNumber;
  String? paymentImage;
  Transportation transportation;
  PaymentMethod paymentMethod;
  DateTime orderDate;
  Status status;

  Order({
    required this.id,
    required this.userId,
    required this.province,
    required this.district,
    required this.village,
    required this.totalAmount,
    required this.phoneNumber,
    required this.paymentImage,
    required this.transportation,
    required this.paymentMethod,
    required this.orderDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['user_id'],
    province: json['province'],
    district: json['district'],
    village: json['village'],
    totalAmount: json['total_amount'],
    phoneNumber: json['phoneNumber'],
    paymentImage: json['payment_image'],
    transportation: TransportationValues.map[json['Transportation']] ?? Transportation.A,
    paymentMethod: PaymentMethodValues.map[json['payment_method']] ?? PaymentMethod.EMPTY,
    orderDate: DateTime.parse(json['order_date']),
    status: StatusValues.map[json['status']] ?? Status.PENDING,
  );
}

// Enums with helpers to parse from string

enum PaymentMethod {
  EMPTY,
  PAYMENT_METHOD,
}

class PaymentMethodValues {
  static Map<String, PaymentMethod> map = {
    "": PaymentMethod.EMPTY,
    "payment_method": PaymentMethod.PAYMENT_METHOD,  // adjust to your backend values
  };
}

enum Status {
  PENDING,
  DELIVERED,
  // add other statuses your backend returns
}

class StatusValues {
  static Map<String, Status> map = {
    "pending": Status.PENDING,
    "delivered": Status.DELIVERED,
  };
}

enum Transportation {
  A,
  B,
}

class TransportationValues {
  static Map<String, Transportation> map = {
    "A": Transportation.A,
    "B": Transportation.B,
  };
}
