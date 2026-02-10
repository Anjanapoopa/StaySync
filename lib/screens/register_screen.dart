import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = "student";

  void registerUser() async {
    final result = await AuthService.register(
      emailController.text,
      passwordController.text,
      role,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"].toString())),
    );

    if (result["message"] == "User registered successfully") {
      Navigator.pop(context); // back to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password")),
            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: "student", child: Text("Student")),
                DropdownMenuItem(value: "warden", child: Text("Warden")),
                DropdownMenuItem(value: "admin", child: Text("Admin")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),
            ElevatedButton(onPressed: registerUser, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
