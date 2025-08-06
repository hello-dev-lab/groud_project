import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/utils/color.dart';
import 'package:firstapp/pages/signin.dart';
import 'package:get_storage/get_storage.dart'; // ใช้สำหรับ AppGradients.customGradient

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final box = GetStorage();
  String _selectedLanguage = Get.locale?.languageCode ?? 'en'; // default 'en'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".tr, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.customGradient),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.customGradient),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [
              // Profile Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Username@gmail.com",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),

              // Menu
              _buildMenuItem(Icons.vpn_key, "password".tr),
              _buildMenuItem(Icons.manage_accounts, "manage your account".tr),
              _buildMenuItem(Icons.settings, "Setting".tr),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.black),
                    const SizedBox(width: 10),
                    DropdownButton(
                      value: _selectedLanguage,
                      items: [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'lo', child: Text('ລາວ')),
                      ],
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          _selectedLanguage = value;
                        });
                        if (value == 'en') {
                          Get.updateLocale(const Locale('en', 'US'));
                        } else if (value == 'lo') {
                          Get.updateLocale(const Locale('lo', 'LA'));
                        }
                        box.write('language', value);
                      },
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Logout
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      "logout".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color? bgColor,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(title, style: TextStyle(color: textColor ?? Colors.black)),
        onTap: () {},
      ),
    );
  }
}
