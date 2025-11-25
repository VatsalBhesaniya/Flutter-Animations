import 'package:fire_cracker_animation/fire_cracker_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diwali Firecrackers',
      theme: ThemeData.dark(),
      home: const FireCrackerAnimation(),
    );
  }
}
