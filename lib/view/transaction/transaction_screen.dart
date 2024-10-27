import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text(
          "Transaction Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
