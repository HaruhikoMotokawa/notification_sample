import 'package:flutter/material.dart';

class DogScreen extends StatelessWidget {
  const DogScreen({super.key});

  static const name = 'DogScreen';
  static const path = '/dog_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('DogScreen'),
      ),
    );
  }
}
