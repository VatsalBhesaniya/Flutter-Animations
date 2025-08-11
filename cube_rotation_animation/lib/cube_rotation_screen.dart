import 'dart:math';
import 'package:flutter/material.dart';

class CubeFace extends StatelessWidget {
  final Color color;
  final Matrix4 transform;

  const CubeFace({super.key, required this.color, required this.transform});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        width: 100,
        height: 100,
        color: color.withValues(alpha: 0.8),
        alignment: Alignment.center,
        child: const Text(
          'Face',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CubeRotationScreen extends StatefulWidget {
  const CubeRotationScreen({super.key});

  @override
  State<CubeRotationScreen> createState() => _CubeRotationScreenState();
}

class _CubeRotationScreenState extends State<CubeRotationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // Perspective
                ..rotateX(_animation.value)
                ..rotateY(_animation.value / 2),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CubeFace(
                    color: Colors.red,
                    transform: Matrix4.translationValues(0, 0, 50),
                  ),
                  CubeFace(
                    color: Colors.green,
                    transform: Matrix4.translationValues(0, 0, -50)..rotateY(pi),
                  ),
                  CubeFace(
                    color: Colors.blue,
                    transform: Matrix4.translationValues(-50, 0, 0)..rotateY(-pi / 2),
                  ),
                  CubeFace(
                    color: Colors.yellow,
                    transform: Matrix4.translationValues(50, 0, 0)..rotateY(pi / 2),
                  ),
                  CubeFace(
                    color: Colors.orange,
                    transform: Matrix4.translationValues(0, -50, 0)..rotateX(-pi / 2),
                  ),
                  CubeFace(
                    color: Colors.purple,
                    transform: Matrix4.translationValues(0, 50, 0)..rotateX(pi / 2),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
