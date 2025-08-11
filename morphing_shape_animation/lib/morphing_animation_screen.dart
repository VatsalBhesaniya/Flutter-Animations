import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MorphingPainter extends CustomPainter {
  final List<Offset> shape1;
  final List<Offset> shape2;
  final double t;

  MorphingPainter(this.shape1, this.shape2, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < shape1.length; i++) {
      final x = lerpDouble(shape1[i].dx, shape2[i].dx, t)!;
      final y = lerpDouble(shape1[i].dy, shape2[i].dy, t)!;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MorphingAnimationScreen extends StatefulWidget {
  const MorphingAnimationScreen({super.key});

  @override
  State<MorphingAnimationScreen> createState() => _MorphingAnimationScreenState();
}

class _MorphingAnimationScreenState extends State<MorphingAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Offset> shape1 = [];
  final List<Offset> shape2 = [];

  @override
  void initState() {
    super.initState();
    _generateShapes();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _generateShapes() {
    // Both shapes must have the same number of points
    for (int i = 0; i < 8; i++) {
      double angle = 2 * pi * i / 8;
      // Circle
      shape1.add(Offset(220 + 80 * cos(angle), 450 + 80 * sin(angle)));
      // Star
      shape2.add(Offset(220 + 80 * cos(angle) * (i % 2 == 0 ? 1 : 0.4),
          450 + 80 * sin(angle) * (i % 2 == 0 ? 1 : 0.4)));
    }
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
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: MorphingPainter(shape1, shape2, _animation.value),
          );
        },
      ),
    );
  }
}
