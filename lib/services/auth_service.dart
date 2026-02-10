import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://localhost:8000"; 
  // Chrome → localhost
  // Android emulator → 10.0.2.2

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      if (data["access_token"] != null) {
        await prefs.setString("access_token", data["access_token"]);
      }
      return data;
    } else {
      return {
        "message": data["detail"] ?? "Login failed",
      };
    }
  }

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return {
        "message": data["detail"] ?? "Registration failed",
      };
    }
  }

  // ================= TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  }
}
