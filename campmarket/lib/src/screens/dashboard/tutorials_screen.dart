import 'package:flutter/material.dart';

class TutorialsScreen extends StatelessWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorials')),
      body: Center(child: const Text('List of Tutorials')),
    );
  }
} 