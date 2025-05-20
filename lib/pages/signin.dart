import 'package:firstapp/pages/signup.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/views/main_screen.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  String emailError = "";
  String passwordError = "";

  void handleLogin() {
    setState(() {
      emailError = emailCtrl.text.isEmpty ? "ກະລຸນາປ້ອນອີເມວ" : "";
      passwordError = passwordCtrl.text.isEmpty ? "ກະລຸນາປ້ອນລະຫັດຜ່ານ" : "";
    });

    if (emailError.isEmpty && passwordError.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
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
                "ເຂົ້າສູ່ລະບົບ",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        errorText:
                            emailError.isNotEmpty
                                ? emailError
                                : null, // ✅ แจ้งเตือนใต้กล่อง
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
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "ປ້ອນລະຫັດຜ່ານ",
                        prefixIcon: Icon(Icons.lock_outlined),
                        errorText:
                            passwordError.isNotEmpty
                                ? passwordError
                                : null, // ✅ แจ้งเตือนใต้กล่อง
                      ),
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ລືມລະຫັດຜ່ານ?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 47, 255),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    GestureDetector(
                      onTap: handleLogin, // ✅ ใช้ฟังก์ชันเช็คข้อมูล
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(gradient: AppGradients.customGradient, borderRadius: BorderRadius.circular(30.0)),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "ເຂົ້າສູ່ລະບົບ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ຍັງບໍ່ທັນມີບັນຊີ?",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                "ລົງທະບຽນ",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 38, 0, 255),
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
          ],
        ),
      ),
    );
  }
}
