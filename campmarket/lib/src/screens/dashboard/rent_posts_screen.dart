import 'package:flutter/material.dart';

class RentPostsScreen extends StatelessWidget {
  const RentPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rent Posts')),
      body: Center(child: const Text('List of Rent Posts')),
    );
  }
} 