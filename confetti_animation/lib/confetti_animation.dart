import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _positions;
  late List<Color> _colors; // Colors for each particle
  late List<double> _velocitiesX; // Horizontal velocities
  late List<double> _velocitiesY; // Vertical velocities
  late List<ShapeType> _shapes; // Shape types for each particle

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _updatePositions();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Clear confetti when animation completes
          _positions.clear();
          _velocitiesX.clear();
          _velocitiesY.clear();
          _shapes.clear();
          setState(() {});
        }
      });

    _positions = List.generate(0, (index) => Offset.zero);
    _colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];
    _shapes = List.generate(0, (index) => ShapeType.circle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    final random = Random();
    _positions = List.generate(
      100,
      (index) =>
          Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2),
    );

    _velocitiesX = List.generate(100, (index) => (random.nextDouble() - 0.5) * 8);
    _velocitiesY = List.generate(100, (index) => -random.nextDouble() * 16);

    _shapes =
        List.generate(100, (index) => ShapeType.values[random.nextInt(ShapeType.values.length)]);

    _controller.reset();
    _controller.forward();
  }

  void _updatePositions() {
    final random = Random();
    for (int i = 0; i < _positions.length; i++) {
      _positions[i] = Offset(
        _positions[i].dx + _velocitiesX[i],
        _positions[i].dy + _velocitiesY[i],
      );

      // Apply gravity to the vertical velocity
      _velocitiesY[i] += 0.3; // Reduced gravity for slower fall

      // Add some randomness to the horizontal velocity for a more natural effect
      _velocitiesX[i] += (random.nextDouble() - 0.5) * 0.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Confetti Animation')),
      body: Stack(
        children: [
          const Center(
            child: Text('Tap the button to see the magic!'),
          ),
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: ConfettiPainter(
              positions: _positions,
              colors: _colors,
              shapes: _shapes,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.celebration),
        onPressed: () {
          startAnimation();
        },
      ),
    );
  }
}

enum ShapeType {
  circle,
  rectangle,
  triangle,
}

class ConfettiPainter extends CustomPainter {
  final List<Offset> positions;
  final List<Color> colors;
  final List<ShapeType> shapes;

  ConfettiPainter({
    required this.positions,
    required this.colors,
    required this.shapes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < positions.length; i++) {
      paint.color = colors[i % colors.length];
      switch (shapes[i]) {
        case ShapeType.circle:
          canvas.drawCircle(positions[i], 5, paint);
          break;
        case ShapeType.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: positions[i],
              width: 10,
              height: 10,
            ),
            paint,
          );
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(positions[i].dx, positions[i].dy - 5);
          path.lineTo(positions[i].dx - 5, positions[i].dy + 5);
          path.lineTo(positions[i].dx + 5, positions[i].dy + 5);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
