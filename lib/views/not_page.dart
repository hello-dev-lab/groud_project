import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';

class NotPage extends StatefulWidget {
  const NotPage({super.key});

  @override
  State<NotPage> createState() => _NotPageState();
}

class _NotPageState extends State<NotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //backgroudcolor
        decoration: BoxDecoration(
          gradient: AppGradients.customGradient,
        ),
      ),
    );
  }
}