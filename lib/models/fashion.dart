import 'package:flutter/material.dart';

class AppModel {
  final String name, image, description, category;
  final double rating;
  final int rewiews, prince;
  List<Color> fcolors;
  List<String> size;
  bool isCheck;

  AppModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.prince,
    required this.rewiews,
    required this.fcolors,
    required this.size,
    required this.description,
    required this.isCheck,
    required this.category,
  });
}

List<AppModel> fashionEcommerceApp = [
  // id:1
  AppModel(
    name: "ເມົາສ໌ເກມມິ່ງ",
    rating: 4.9,
    image: "images/mouse1.png",
    prince: 469000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌",
  ),

  AppModel(
    name: "ເມົາສ໌ເກມມິ່ງ",
    rating: 4.9,
    image: "images/mouse3.png",
    prince: 599000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.blue, Colors.black],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌",
  ),
  AppModel(
    name: "ເມົາສ໌ເກມມິ່ງ",
    rating: 4.9,
    image: "images/mouse4.png",
    prince: 399000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌",
  ),

  // id:2
  AppModel(
    name: "ຄີບອດ led",
    rating: 4.9,
    image: "images/keyboard3.png",
    prince: 489000,
    rewiews: 150,
    isCheck: true,
    category: "ຄີບອດ",
    fcolors: [Colors.white, Colors.red, Colors.amber],
    size: ["S", "M", "L"],
    description: "ນີ້ແມ່ນຄຳອະທີບາຍຂອງຄີບອດ",
  ),

  AppModel(
    name: "ຄີບອດ led",
    rating: 4.9,
    image: "images/keyboard4.png",
    prince: 359000,
    rewiews: 150,
    isCheck: true,
    category: "ຄີບອດ",
    fcolors: [Colors.white, Colors.red, Colors.amber],
    size: ["S", "M", "L"],
    description: "ນີ້ແມ່ນຄຳອະທີບາຍຂອງຄີບອດ",
  ),

  // id:3
  AppModel(
    name: "Oversize Fit Printed Mesh T-Shirt",
    rating: 4.9,
    image: "images/moseee.png",
    prince: 300000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ffff",
  ),

  // id:4
  AppModel(
    name: "Oversize Fit Printed Mesh T-Shirt",
    rating: 4.9,
    image: "images/keyb.png",
    prince: 4000000,
    rewiews: 150,
    isCheck: true,
    category: "ຄີບອດ",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "",
  ),
  // id:5
  AppModel(
    name: "Oversize Fit Printed Mesh T-Shirt",
    rating: 4.9,
    image: "images/mouse5.png",
    prince: 200000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "",
  ),

  // id:6
  AppModel(
    name: "ເມົາສ໌ເກມມິ່ງ",
    rating: 4.9,
    image: "images/mouse2.png",
    prince: 469000,
    rewiews: 150,
    isCheck: true,
    category: "ເມົາສ໌",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌ນີ້ເປັນຄຳອະທີບາຍຂອງເມົາສ໌",
  ),

  AppModel(
    name: "ຫູຟັງ",
    rating: 4.9,
    image: "images/headphone1.png",
    prince: 469000,
    rewiews: 150,
    isCheck: true,
    category: "ຫູຟັງ",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງຫູຟັງ",
  ),
  AppModel(
    name: "ຫູຟັງ",
    rating: 4.9,
    image: "images/headphone2.png",
    prince: 469000,
    rewiews: 150,
    isCheck: true,
    category: "ຫູຟັງ",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງຫູຟັງ",
  ),
  AppModel(
    name: "ຫູຟັງ",
    rating: 4.9,
    image: "images/headphone3.png",
    prince: 469000,
    rewiews: 150,
    isCheck: true,
    category: "ຫູຟັງ",
    fcolors: [Colors.white, Colors.pink, Colors.yellow],
    size: ["S", "M", "L"],
    description: "ນີ້ເປັນຄຳອະທີບາຍຂອງຫູຟັງ",
  ),
];
