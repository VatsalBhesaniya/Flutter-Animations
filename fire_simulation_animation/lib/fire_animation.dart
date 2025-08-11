import 'dart:math';
import 'package:flutter/material.dart';

class FireParticle {
  Offset position;
  double radius;
  Color color;
  double opacity;
  double lifetime;
  double age;
  double dx;

  FireParticle({
    required this.position,
    required this.radius,
    required this.color,
    required this.opacity,
    required this.lifetime,
    required this.age,
    required this.dx,
  });

  void update(double deltaTime) {
    age += deltaTime;
    double lifeProgress = age / lifetime;
    position = Offset(position.dx + dx, position.dy - 1.5);
    opacity = (1 - lifeProgress).clamp(0.0, 1.0);
    radius *= (0.99 + Random().nextDouble() * 0.01); // subtle shrink
  }

  bool get isAlive => age < lifetime;
}

class FirePainter extends CustomPainter {
  final List<FireParticle> particles;
  final Paint firePaint;

  FirePainter(this.particles) : firePaint = Paint()..blendMode = BlendMode.plus;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      firePaint.color = particle.color.withValues(alpha: particle.opacity);
      canvas.drawCircle(particle.position, particle.radius, firePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FireAnimation extends StatefulWidget {
  const FireAnimation({super.key});

  @override
  State<FireAnimation> createState() => _FireAnimationState();
}

class _FireAnimationState extends State<FireAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FireParticle> _particles = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..addListener(_updateParticles)
      ..repeat();
  }

  void _updateParticles() {
    final deltaTime = 1 / 60;

    // Update particles
    for (final particle in _particles) {
      particle.update(deltaTime);
    }

    // Remove dead particles
    _particles.removeWhere((p) => !p.isAlive);

    // Spawn new particles slowly
    if (_particles.length < 100) {
      _spawnParticle();
    }

    setState(() {});
  }

  void _spawnParticle() {
    final dx = (_random.nextDouble() - 0.5) * 2;
    final position = Offset(200 + dx * 5, 500); // base of the fire
    final radius = 10 + _random.nextDouble() * 8;
    final color = Color.lerp(Colors.deepOrange, Colors.yellowAccent, _random.nextDouble())!;
    final lifetime = 1.5 + _random.nextDouble();
    final dxDrift = (_random.nextDouble() - 0.5) * 0.8;

    _particles.add(FireParticle(
      position: position,
      radius: radius,
      color: color,
      opacity: 1,
      lifetime: lifetime,
      age: 0,
      dx: dxDrift,
    ));
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
      body: CustomPaint(
        painter: FirePainter(_particles),
      ),
    );
  }
}
