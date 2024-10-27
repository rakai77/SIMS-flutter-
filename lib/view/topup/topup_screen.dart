import 'package:flutter/material.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up"),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text(
          "Top Up Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
