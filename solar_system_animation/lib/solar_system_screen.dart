import 'dart:math';
import 'package:flutter/material.dart';

class SolarSystemPainter extends CustomPainter {
  final double time;

  SolarSystemPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final Paint orbitPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke;

    // Draw orbits
    canvas.drawCircle(center, 70, orbitPaint);
    canvas.drawCircle(center, 140, orbitPaint);
    canvas.drawCircle(center, 200, orbitPaint);

    // Draw Sun
    double sunX = center.dx;
    double sunY = center.dy;
    final Paint sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellowAccent, Colors.transparent],
        stops: [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(sunX, sunY), radius: 90));
    canvas.drawCircle(Offset(sunX, sunY), 90, sunPaint);

    // Draw Venus (Orbiting around the Sun)
    double venusOrbitRadius = 70;
    double venusX = center.dx + venusOrbitRadius * cos(time * 3);
    double venusY = center.dy + venusOrbitRadius * sin(time * 3);
    final Paint venusPaint = Paint()..color = Colors.orange;
    canvas.drawCircle(Offset(venusX, venusY), 15, venusPaint);

    // Draw Earth (Orbiting around the Sun)
    double earthOrbitRadius = 140;
    double earthX = center.dx + earthOrbitRadius * cos(time);
    double earthY = center.dy + earthOrbitRadius * sin(time);
    final Paint earthPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.blueAccent, Colors.transparent],
        stops: [0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(earthX, earthY), radius: 25));
    canvas.drawCircle(Offset(earthX, earthY), 25, earthPaint);

    // Draw Moon orbiting Earth
    double moonOrbitRadius = 30;
    double moonX = earthX + moonOrbitRadius * cos(time * 2);
    double moonY = earthY + moonOrbitRadius * sin(time * 2);
    final Paint moonPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, Colors.transparent],
        stops: [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(moonX, moonY), radius: 15));
    canvas.drawCircle(Offset(moonX, moonY), 15, moonPaint);

    // Draw Mars (Orbiting around the Sun)
    double marsOrbitRadius = 200;
    double marsX = center.dx + marsOrbitRadius * cos(time * 2);
    double marsY = center.dy + marsOrbitRadius * sin(time * 2);
    final Paint marsPaint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(marsX, marsY), 10, marsPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SolarSystemScreen extends StatefulWidget {
  const SolarSystemScreen({super.key});

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
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
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SolarSystemPainter(time: _controller.value * 2 * pi),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
