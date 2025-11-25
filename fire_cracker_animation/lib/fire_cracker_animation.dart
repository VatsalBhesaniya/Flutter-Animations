import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FireCrackerAnimation extends StatefulWidget {
  const FireCrackerAnimation({super.key});

  @override
  State<FireCrackerAnimation> createState() => _FireCrackerAnimationState();
}

class _FireCrackerAnimationState extends State<FireCrackerAnimation> with TickerProviderStateMixin {
  late AudioPlayer player = AudioPlayer();
  final List<Firecracker> firecrackers = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    // Auto-launch firecrackers
    Future.delayed(const Duration(milliseconds: 500), autoLaunch);
  }

  @override
  void dispose() {
    player.dispose();
    for (var fc in firecrackers) {
      fc.controller.dispose();
    }
    super.dispose();
  }

  void autoLaunch() {
    if (mounted) {
      launchFirecracker(random.nextDouble() * 400 + 50, random.nextDouble() * 300 + 100);
      Future.delayed(Duration(milliseconds: random.nextInt(800) + 400), autoLaunch);
    }
  }

  void launchFirecracker(double x, double y) {
    player.play(AssetSource('sounds/cracker_${random.nextInt(7) + 1}.mp3'), volume: 0.5);
    final controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final firecracker = Firecracker(
      x: x,
      y: y,
      controller: controller,
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.pink,
        Colors.purple,
        Colors.blue,
        Colors.green,
      ]..shuffle(random),
    );

    setState(() {
      firecrackers.add(firecracker);
    });

    controller.forward().then((_) {
      setState(() {
        firecrackers.remove(firecracker);
      });
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      body: GestureDetector(
        onTapDown: (details) {
          launchFirecracker(details.localPosition.dx, details.localPosition.dy);
        },
        child: Stack(
          children: [
            // Title
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    '🎆 Happy Diwali 2025 🎆',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[300],
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.orange, offset: const Offset(0, 0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap anywhere to launch firecrackers!',
                    style: TextStyle(fontSize: 16, color: Colors.amber[100]),
                  ),
                ],
              ),
            ),
            // Firecrackers
            ...firecrackers.map(
              (fc) => AnimatedBuilder(
                animation: fc.controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: FirecrackerPainter(
                      progress: fc.controller.value,
                      x: fc.x,
                      y: fc.y,
                      colors: fc.colors,
                    ),
                    child: Container(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Firecracker {
  final double x;
  final double y;
  final AnimationController controller;
  final List<Color> colors;

  Firecracker({required this.x, required this.y, required this.controller, required this.colors});
}

class FirecrackerPainter extends CustomPainter {
  final double progress;
  final double x;
  final double y;
  final List<Color> colors;
  final Random random = Random();

  FirecrackerPainter({
    required this.progress,
    required this.x,
    required this.y,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final particleCount = 50;
    final maxRadius = 150.0;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi;
      final speed = 0.5 + random.nextDouble() * 0.5;

      // Explosion phase (0.0 to 0.6)
      // Fade phase (0.6 to 1.0)
      final explosionProgress = (progress / 0.6).clamp(0.0, 1.0);
      final fadeProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);

      final distance = maxRadius * explosionProgress * speed;
      final particleX = x + cos(angle) * distance;
      final particleY = y + sin(angle) * distance + (progress * 30); // Gravity

      final opacity = (1.0 - fadeProgress) * (1.0 - progress * 0.3);
      final particleSize = 4.0 * (1.0 - progress) * speed;

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // Draw particle with glow
      canvas.drawCircle(Offset(particleX, particleY), particleSize, paint);

      // Glow effect
      if (progress < 0.5) {
        final glowPaint = Paint()
          ..color = colors[i % colors.length].withValues(alpha: opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(particleX, particleY), particleSize * 2, glowPaint);
      }
    }

    // Core flash (first 20% of animation)
    if (progress < 0.2) {
      final flashOpacity = (1.0 - progress / 0.2) * 0.8;
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: flashOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawCircle(Offset(x, y), 20, flashPaint);
    }
  }

  @override
  bool shouldRepaint(FirecrackerPainter oldDelegate) => true;
}
