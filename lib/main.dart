import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sims/view/home/home_screen.dart';
import 'package:sims/view/login/login_screen.dart';
import 'package:sims/view/profile/profile_screen.dart';
import 'package:sims/view/register/register_screen.dart';
import 'package:sims/view/splash/splash_screen.dart';
import 'package:sims/view/topup/topup_screen.dart';
import 'package:sims/view/transaction/transaction_screen.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('authBox'); // Open a box for storing authentication data
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
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
