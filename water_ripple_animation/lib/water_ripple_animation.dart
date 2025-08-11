import 'package:flutter/material.dart';

class Ripple {
  Offset center;
  double radius;
  double alpha;

  Ripple({
    required this.center,
    required this.radius,
    required this.alpha,
  });
}

class RipplePainter extends CustomPainter {
  final List<Ripple> ripples;

  RipplePainter({required this.ripples});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    for (final ripple in ripples) {
      paint.color = Colors.blue.withValues(alpha: ripple.alpha);
      paint.strokeWidth = 2.0;
      canvas.drawCircle(ripple.center, ripple.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaterRippleAnimation extends StatefulWidget {
  const WaterRippleAnimation({super.key});

  @override
  State<WaterRippleAnimation> createState() => _WaterRippleAnimationState();
}

class _WaterRippleAnimationState extends State<WaterRippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Ripple> _ripples = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {
          _updateRipples();
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateRipples() {
    for (var ripple in _ripples) {
      ripple.radius += 2.0;
      ripple.alpha -= 0.02;
    }

    _ripples.removeWhere((ripple) => ripple.alpha <= 0);
  }

  void _createRipple(Offset position) {
    setState(() {
      _ripples.add(
        Ripple(center: position, radius: 0, alpha: 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Water Ripple Animation'),
      ),
      body: GestureDetector(
        onTapDown: (details) => _createRipple(details.localPosition),
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: RipplePainter(ripples: _ripples),
        ),
      ),
    );
  }
}
