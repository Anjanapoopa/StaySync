import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const StaySyncApp());
}

class StaySyncApp extends StatelessWidget {
  const StaySyncApp({super.key});

  // Check token for auto login
  Future<bool> checkLogin() async {
    final token = await AuthService.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StaySync',
      theme: ThemeData(primarySwatch: Colors.blue),

      // -------- ROUTES --------
      routes: {
        "/welcome": (context) => const WelcomeScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
      },

      // -------- STARTING SCREEN --------
      home: FutureBuilder<bool>(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Token undenkil → Home
          // Illenkil → Welcome screen
          return snapshot.data!
              ? const HomeScreen()
              : const WelcomeScreen();
        },
      ),
    );
  }
}
