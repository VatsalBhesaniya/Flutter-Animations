import 'package:flutter/material.dart';

class CustomLoadingAnimation extends StatefulWidget {
  const CustomLoadingAnimation({super.key});

  @override
  State<CustomLoadingAnimation> createState() => _CustomLoadingAnimationState();
}

class _CustomLoadingAnimationState extends State<CustomLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // return Transform.rotate(
        //   angle: _controller.value * 2 * 3.1416,
        //   child: child,
        // );
        return Transform.scale(
          scale: 0.8 + 0.2 * (1 - _controller.value).abs(), // creates a scaling factor
          child: Transform.rotate(
            angle: _controller.value * 2 * 3.1416,
            child: child,
          ),
        );
      },
      child: _buildCircle(),
    );
  }

  Widget _buildCircle() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          // colors: [Colors.blue, Colors.blue.shade200],
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
