import 'package:flutter/material.dart';

class SellPostsScreen extends StatelessWidget {
  const SellPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sell Posts')),
      body: Center(child: const Text('List of Sell Posts')),
    );
  }
} 