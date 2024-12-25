import 'package:flutter/material.dart';

class ExchangePostsScreen extends StatelessWidget {
  const ExchangePostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exchange Posts')),
      body: Center(child: const Text('List of Exchange Posts')),
    );
  }
} 