import 'dart:convert';
import 'package:firstapp/api/api_path.dart';
import 'package:http/http.dart' as http;

class AdminServices {
  static Future<http.Response> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await http.post(
      Uri.parse(ApiPath.SIGNUP),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'userName': username,
      }),
    );
    return response;
  }
}