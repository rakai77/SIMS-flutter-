import 'package:flutter/material.dart';
import 'package:sims/view/home/home_screen.dart';
import 'package:sims/view/login/login_screen.dart';
import 'package:sims/view/profile/profile_screen.dart';
import 'package:sims/view/register/register_screen.dart';
import 'package:sims/view/topup/topup_screen.dart';
import 'package:sims/view/transaction/transaction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMS PPBI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/topup': (context) => const TopUpScreen(),
        '/transaction': (context) => const TransactionScreen(),
        '/profile': (context) => const ProfileScreen()
      }
    );
  }
}
