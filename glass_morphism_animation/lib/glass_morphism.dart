import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final double offset;

  BackgroundPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple, Colors.indigo, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(Offset(size.width * 0.3 + offset, size.height * 0.4), 200, paint);
    canvas.drawCircle(Offset(size.width * 0.7 - offset, size.height * 0.6), 150, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) => true;
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 20), vsync: this)
      ..repeat(reverse: true);

    _animation = Tween(
      begin: -100.0,
      end: 100.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(painter: BackgroundPainter(offset: _animation.value));
      },
    );
  }
}

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GlassContainer({super.key, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          Center(
            child: GlassContainer(
              width: 300,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Glassmorphism UI",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
