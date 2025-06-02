// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient customGradient = LinearGradient(
    colors: [
      Color(0xFF2A3236), // จางลงจาก 0xFF0C0F10
      Color(0xFF3C4C52), // จางลงจาก 0xFF1A2A30
      Color(0xFF4B5F68),
    ],
    begin: Alignment.topCenter, // เริ่มต้นจากด้านบนกลาง
    end: Alignment.topRight, // ไปสิ้นสุดที่มุมขวาบน
  );

  AppGradients(colors);
}

Color bannerColor = const Color(0xffc4d1da);
