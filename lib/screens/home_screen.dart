import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = ""; // Optional: show user email

  @override
  void initState() {
    super.initState();
    loadUserEmail();
  }

  // Example: load email from SharedPreferences if saved
  Future<void> loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("user_email") ?? "";
    if (!mounted) return;
    setState(() {
      email = savedEmail;
    });
  }

  // Logout safely
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    await prefs.remove("user_email"); // optional cleanup

    if (!mounted) return; // ✅ Guard against async gap

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, // Safe async call
          ),
        ],
      ),
      body: Center(
        child: Text(
          email.isNotEmpty
              ? "Welcome, $email!"
              : "Welcome to StaySync!",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
