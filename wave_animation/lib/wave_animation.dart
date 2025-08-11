import 'dart:math';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double time;

  WavePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blueAccent.withValues(alpha: 0.6), Colors.indigo.withValues(alpha: 0.5)],
    );

    final reflectionGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
    );

    final paintMain = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final paintInner = Paint()
      ..color = Colors.lightBlueAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final reflectionPaint = Paint()
      ..shader = reflectionGradient.createShader(
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
      )
      ..blendMode = BlendMode.lighten
      ..style = PaintingStyle.fill;

    final pathMain = Path();
    final pathInner = Path();

    double dynamicHeight = 30 + sin(time * 2 * pi) * 10;
    double innerWaveOffset = 10;
    double waveSpeed = 2;
    double fullCycle = size.width;

    pathMain.moveTo(0, size.height);
    pathInner.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      double yMain =
          sin((x / fullCycle * 2 * pi) + (time * waveSpeed * 2 * pi)) * dynamicHeight +
          size.height / 2;
      double yInner =
          sin((x / fullCycle * 2 * pi) + (time * waveSpeed * 2 * pi) + pi / 4) *
              (dynamicHeight - innerWaveOffset) +
          size.height / 2;
      pathMain.lineTo(x, yMain);
      pathInner.lineTo(x, yInner);
    }

    pathMain.lineTo(size.width, size.height);
    pathMain.close();

    pathInner.lineTo(size.width, size.height);
    pathInner.close();

    canvas.drawPath(pathMain, paintMain);
    canvas.drawPath(pathInner, paintInner);

    // Draw reflection
    canvas.save();
    canvas.translate(0, size.height);
    canvas.scale(1, -1);
    canvas.drawPath(pathMain, reflectionPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(time: _controller.value),
            child: Container(),
          );
        },
      ),
    );
  }
}
