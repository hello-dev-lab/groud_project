import 'dart:convert';
import 'package:firstapp/pages/signin.dart';
import 'package:firstapp/services/admin_sercies.dart';
import 'package:firstapp/utils/color.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  bool isloading = false;
  bool showPassword = false;

  String nameError = "";
  String emailError = "";
  String passwordError = "";

  bool validateForm() {
    setState(() {
      nameError = usernameCtrl.text.isEmpty ? "ກະລຸນາປ້ອນຊື່" : "";
      emailError = emailCtrl.text.isEmpty ? "ກະລຸນາປ້ອນອີເມວ" : "";
      passwordError = passwordCtrl.text.isEmpty ? "ກະລຸນາປ້ອນລະຫັດຜ່ານ" : "";
    });

    return nameError.isEmpty && emailError.isEmpty && passwordError.isEmpty;
  }

  Future<void> _register() async {
    setState(() {
      isloading = true;
    });

    try {
      final response = await AdminServices.register(
        email: emailCtrl.text,
        password: passwordCtrl.text,
        username: usernameCtrl.text,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['message'] ?? 'Registration successful!',
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['error'] ?? 'Invalid input data.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed! Status code: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error. Please check your connection.')),
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                "ສ້າງບັນຊີໃຫມ່ຂອງທ່ານ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ຊື່ແລະນາມສະກຸນ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: usernameCtrl,
                        decoration: InputDecoration(
                          hintText: "ປ້ອນຊື່ແລະນາມສະກຸນ",
                          prefixIcon: Icon(Icons.person_outline),
                          errorText: nameError.isNotEmpty ? nameError : null,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "ອີເມວ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          hintText: "ປ້ອນອີເມວ",
                          prefixIcon: Icon(Icons.email_outlined),
                          errorText: emailError.isNotEmpty ? emailError : null,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "ລະຫັດຜ່ານ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: passwordCtrl,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          hintText: "ປ້ອນລະຫັດຜ່ານ",
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                          errorText:
                              passwordError.isNotEmpty ? passwordError : null,
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap:
                            isloading
                                ? null
                                : () {
                                  if (validateForm()) {
                                    _register();
                                  }
                                },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            gradient: AppGradients.customGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child:
                                isloading
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      "ລົງທະບຽນ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "ມີບັນຊີຢູ່ແລ້ວ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18.0,
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    isloading
                                        ? null
                                        : () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SignIn(),
                                            ),
                                          );
                                        },
                                child: Text(
                                  "ເຂົ້າສູ່ລະບົບ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 38, 0, 255),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
