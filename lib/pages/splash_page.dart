import 'dart:async';
import 'dart:convert';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/pages/onboarding.dart';
import 'package:firstapp/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitData();
  }

  final storage = const FlutterSecureStorage();

  Future<void> onInitData() async {
    try {
      String? token = await storage.read(key: 'token');
      print('Token: $token');

      if (token == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding()),
          (route) => false,
        );
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request('GET', Uri.parse(ApiPath.VerifyToken));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var body = jsonDecode(await response.stream.bytesToString());
        print('Response body: $body');

        if (body['success'] == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding()),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error: $e');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
        (route) => false,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.abc, size: 100),
            SizedBox(height: 20),
            Text('Splash Screen', style: TextStyle(fontSize: 30)),
            const CircularProgressIndicator(
            color: Colors.white, // optional: change color
            strokeWidth: 4.0,
          ),
          ],
        ),
      ),
    );
  }
}
