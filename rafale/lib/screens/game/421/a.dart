import 'package:flutter/material.dart';


class A extends StatelessWidget {
  const A({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test de lien'),
        ),
        body: const Center(
          child: Text(
            'Hello',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
