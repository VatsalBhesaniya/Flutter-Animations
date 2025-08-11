import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class WeatherScene extends StatefulWidget {
  const WeatherScene({super.key});
  @override
  State<WeatherScene> createState() => _WeatherSceneState();
}

class _WeatherSceneState extends State<WeatherScene> with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _rainController;
  bool _isFlashing = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    )..repeat();

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    )..repeat();

    _startFlashTimer();
  }

  void _startFlashTimer() {
    _flashTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      final shouldFlash = Random().nextDouble() > 0.75;
      if (shouldFlash) {
        setState(() => _isFlashing = true);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _isFlashing = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _rainController.dispose();
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildSkyGradient(),
          _buildSun(),
          _buildClouds(),
          _buildRain(),
          _buildLightning(),
        ],
      ),
    );
  }

  Widget _buildSkyGradient() {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0d47a1), Color(0xff90caf9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildSun() {
    return Positioned(
      top: 100,
      right: 60,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Colors.yellow, Colors.orangeAccent],
            radius: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withValues(alpha: 0.6),
              blurRadius: 50,
              spreadRadius: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClouds() {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return Positioned(
          top: 50,
          left: MediaQuery.of(context).size.width * _cloudController.value - 200,
          child: Opacity(
            opacity: 0.7,
            child: Image.asset('assets/cloud.png', width: 300),
          ),
        );
      },
    );
  }

  Widget _buildRain() {
    return AnimatedBuilder(
      animation: _rainController,
      builder: (_, __) {
        return CustomPaint(
          painter: RainPainter(_rainController.value),
          child: Container(),
        );
      },
    );
  }

  Widget _buildLightning() {
    final flashOpacity = Random().nextDouble() * 0.3 + 0.2;
    final flashDuration = Duration(milliseconds: Random().nextInt(100) + 50);
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: _isFlashing ? flashOpacity : 0.0,
        duration: flashDuration,
        child: Container(color: Colors.white),
      ),
    );
  }
}

class RainPainter extends CustomPainter {
  final double value;
  RainPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade200
      ..strokeWidth = 2;

    final random = Random(12345);
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final length = random.nextDouble() * 20 + 10;
      final offsetY = (value * size.height + i * 15) % size.height;
      canvas.drawLine(Offset(x, offsetY), Offset(x, offsetY + length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
