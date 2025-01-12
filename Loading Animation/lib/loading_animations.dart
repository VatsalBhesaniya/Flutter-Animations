import 'package:flutter/material.dart';
import 'package:loading_animation/custom_loading_animation.dart';
import 'package:loading_animation/gradient_loading_animation.dart';

class LoadingAnimationScreen extends StatelessWidget {
  const LoadingAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Custom Loading Animation',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            CustomLoadingAnimation(),
            SizedBox(height: 100),
            Text(
              'Gradient Loading Animation',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            GradientLoadingAnimation(),
          ],
        ),
      ),
    );
  }
}
