import 'package:flutter/material.dart';

class BounceAnimationContainer extends StatefulWidget {
  const BounceAnimationContainer({super.key});

  @override
  State<BounceAnimationContainer> createState() => _BounceAnimationContainerState();
}

class _BounceAnimationContainerState extends State<BounceAnimationContainer> {
  double _size = 100;

  void _startAnimation() {
    setState(() {
      _size = _size == 100 ? 200 : 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: GestureDetector(
          onTap: _startAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.bounceOut,
            width: _size,
            height: _size,
            decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
