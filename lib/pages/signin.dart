import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/pages/signup.dart';
import 'package:firstapp/views/main_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword = true;
  bool isLoading = false;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  String emailError = '';
  String passwordError = '';

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiPath.baseUrl}user/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailCtrl.text.trim(),
          'password': passwordCtrl.text.trim(),
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await storage.write(key: 'token', value: responseBody['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login success')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        setState(() {
          emailError = 'Invalid email or password';
          passwordError = 'Invalid email or password';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      print("Network error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text(
                  "ເຂົ້າສູ່ລະບົບ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ອີເມວ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          hintText: "ປ້ອນອີເມວ",
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: emailError.isNotEmpty ? emailError : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "ລະຫັດຜ່ານ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          hintText: "ປ້ອນລະຫັດຜ່ານ",
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                          errorText: passwordError.isNotEmpty ? passwordError : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "ລືມລະຫັດຜ່ານ?",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      GestureDetector(
                        onTap: isLoading ? null : handleLogin,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppGradients.customGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "ເຂົ້າສູ່ລະບົບ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "ຍັງບໍ່ທັນມີບັນຊີ?",
                              style: TextStyle(color: Colors.black54, fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUp()),
                                );
                              },
                              child: const Text(
                                "ລົງທະບຽນ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 38, 0, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
