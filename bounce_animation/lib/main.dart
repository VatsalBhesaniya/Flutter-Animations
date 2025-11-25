import 'package:bounce_animation/bounce_animation_container.dart';
import 'package:bounce_animation/bounce_animation_controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounce Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      // home: const BounceAnimationContainer(),
      home: const BounceAnimationController(),
    );
  }
}
