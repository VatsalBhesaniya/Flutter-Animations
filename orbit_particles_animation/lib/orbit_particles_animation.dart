import 'dart:math';
import 'package:flutter/material.dart';

class OrbitPainter extends CustomPainter {
  final Animation<double> animation;

  OrbitPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.8);

    const int particleCount = 100;
    final double radius = size.width / 2;

    for (int i = 0; i < particleCount; i++) {
      double angle = 2 * pi * i / particleCount + animation.value * 2 * pi;

      final double orbitRadius = radius * (0.3 + (i % 5) * 0.1);
      final double x = center.dx + orbitRadius * cos(angle);
      final double y = center.dy + orbitRadius * sin(angle);

      canvas.drawCircle(Offset(x, y), 2, paint..color = _getColor(i));
    }
  }

  Color _getColor(int index) {
    final hue = (index * 3) % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 1, 1).toColor();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OrbitParticlesAnimation extends StatefulWidget {
  const OrbitParticlesAnimation({super.key});

  @override
  State<OrbitParticlesAnimation> createState() => _OrbitParticlesAnimationState();
}

class _OrbitParticlesAnimationState extends State<OrbitParticlesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
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
        child: CustomPaint(
          painter: OrbitPainter(animation: _controller),
          size: const Size(300, 300),
        ),
      ),
    );
  }
}
