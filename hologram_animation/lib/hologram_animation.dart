import 'dart:math';
import 'package:flutter/material.dart';

class HologramPainter extends CustomPainter {
  final double animationValue;
  HologramPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint hologramPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.cyanAccent, Colors.blueAccent.withValues(alpha: 0.1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)))
      ..blendMode = BlendMode.lighten;

    final Paint scanlinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw a triangular hologram effect
    Path hologramPath = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(hologramPath, hologramPaint);

    // Add animated scanlines effect
    for (double i = 0; i < size.height; i += 10) {
      double yOffset = i + (animationValue * 10);
      canvas.drawLine(Offset(0, yOffset), Offset(size.width, yOffset), scanlinePaint);
    }
  }

  @override
  bool shouldRepaint(HologramPainter oldDelegate) => true;
}

class HologramAnimation extends StatefulWidget {
  const HologramAnimation({super.key});

  @override
  State<HologramAnimation> createState() => _HologramAnimationState();
}

class _HologramAnimationState extends State<HologramAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateY(pi * _controller.value) // 3D Rotation effect
              ..rotateX(sin(_controller.value * 2 * pi) * 0.2),
            child: CustomPaint(
              painter: HologramPainter(_controller.value),
              size: const Size(200, 300),
            ),
          );
        },
      ),
    );
    // return SafeArea(
    //   child: ShaderMask(
    //     shaderCallback: (bounds) {
    //       return RadialGradient(
    //         colors: [Colors.cyanAccent, Colors.transparent],
    //         radius: 1.5,
    //       ).createShader(bounds);
    //     },
    //     blendMode: BlendMode.srcATop,
    //     child: AnimatedBuilder(
    //       animation: _controller,
    //       builder: (context, child) {
    //         return Transform(
    //           alignment: Alignment.center,
    //           transform: Matrix4.identity()
    //             ..rotateY(pi * _controller.value)
    //             ..rotateX(sin(_controller.value * 2 * pi) * 0.2),
    //           child: CustomPaint(
    //             painter: HologramPainter(_controller.value),
    //             size: const Size(200, 300),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
