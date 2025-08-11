import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  late Offset position;
  late Offset velocity;
  late double size;
  late Color color;
  final Random random = Random();

  Particle() {
    reset();
  }

  void reset() {
    position = Offset(random.nextDouble() * 800, random.nextDouble() * 800);
    velocity = Offset((random.nextDouble() - 0.5) * 2, (random.nextDouble() - 0.5) * 2);
    size = random.nextDouble() * 3 + 1;
    color = Colors.accents[random.nextInt(Colors.accents.length)].withValues(alpha: 0.6);
  }

  void update() {
    position += velocity;
    if (position.dx < 0 || position.dx > 800 || position.dy < 0 || position.dy > 800) {
      reset();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(p.position, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleField extends StatefulWidget {
  const ParticleField({super.key});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final int particleCount = 150;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(particleCount, (index) => Particle());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            for (var p in _particles) {
              p.update();
            }
            return CustomPaint(
              painter: ParticlePainter(_particles),
              size: MediaQuery.of(context).size,
            );
          },
        ),
      ),
    );
  }
}
