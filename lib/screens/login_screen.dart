import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:staysync_app/screens/home_screen.dart';
import 'package:staysync_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = "";

  // ✅ EMAIL VALIDATION FUNCTION
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  // -------- LOGIN FUNCTION --------
  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ✅ email validation
    if (!isValidEmail(email)) {
      setState(() {
        message = "Enter full email address (abc@gmail.com)";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        message = "Password required";
      });
      return;
    }

    setState(() {
      message = "Processing...";
    });

    try {
      final response = await AuthService.login(email, password);

      if (!mounted) return;

      if (response['access_token'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          message = response['message'] ?? "Login failed";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        message = "Server connection error";
      });
    }
  }

  // -------- BUILD --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("StaySync Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loginUser,
              child: const Text("Login"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),

            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
