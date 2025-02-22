import 'dart:math';
import 'package:flutter/material.dart';

class ParticleExplosion extends StatefulWidget {
  const ParticleExplosion({super.key});

  @override
  State<ParticleExplosion> createState() => _ParticleExplosionState();
}

class _ParticleExplosionState extends State<ParticleExplosion> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });

    _particles = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles(Offset tapPosition) {
    final random = Random();
    _particles = List.generate(100, (_) {
      final direction = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 5 + 2;

      return Particle(
        position: tapPosition,
        velocity: Offset(cos(direction) * speed, sin(direction) * speed),
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        size: random.nextDouble() * 4 + 2,
        lifetime: 1.0,
      );
    });

    _controller.reset();
    _controller.forward();
  }

  void _updateParticles() {
    for (final particle in _particles) {
      particle.position += particle.velocity;
      particle.lifetime -= 0.02;
    }
    _particles.removeWhere((particle) => particle.lifetime <= 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _generateParticles(details.localPosition),
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: ParticlePainter(particles: _particles),
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifetime;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifetime,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      paint.color = particle.color.withValues(alpha: particle.lifetime);
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
