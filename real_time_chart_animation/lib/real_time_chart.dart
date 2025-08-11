import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class RealTimeChart extends StatefulWidget {
  const RealTimeChart({super.key});

  @override
  State<RealTimeChart> createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> with SingleTickerProviderStateMixin {
  final List<double> _dataPoints = [];
  final Random _random = Random();
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousPoint = 100;
  double _currentPoint = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _addDataPoint();
    });
  }

  void _addDataPoint() {
    setState(() {
      _previousPoint = _currentPoint;
      _currentPoint = (_previousPoint + (_random.nextDouble() * 40 - 20)).clamp(10.0, 200.0);

      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 300,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blueGrey.shade200,
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final interpolatedPoint =
                  _previousPoint + (_currentPoint - _previousPoint) * _animation.value;
              _dataPoints.add(interpolatedPoint);
              if (_dataPoints.length > 1000) {
                _dataPoints.removeAt(0);
              }
              return CustomPaint(
                painter: LineChartPainter(_dataPoints),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> points;

  LineChartPainter(this.points);

  void _drawDottedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dash = 5,
    double gap = 5,
  }) {
    final Path path = Path();
    double currentLength = 0;

    final double totalLength = (p2 - p1).distance;
    final double angle = (p2 - p1).direction;

    while (currentLength < totalLength) {
      path.moveTo(
        p1.dx + currentLength * cos(angle),
        p1.dy + currentLength * sin(angle),
      );
      currentLength += dash;
      if (currentLength > totalLength) {
        currentLength = totalLength;
      }
      path.lineTo(
        p1.dx + currentLength * cos(angle),
        p1.dy + currentLength * sin(angle),
      );
      currentLength += gap;
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blueGrey.shade700
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Paint gridPaint = Paint()
      ..color = Colors.blueGrey.shade200
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    const int internalHorizontalGridLines = 5;
    if (size.height > 0 && internalHorizontalGridLines > 0) {
      final double horizontalStep = size.height / (internalHorizontalGridLines + 1);
      for (int i = 1; i <= internalHorizontalGridLines; i++) {
        final y = size.height - (i * horizontalStep);
        _drawDottedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Draw vertical grid lines
    const int internalVerticalGridLines = 7;
    if (size.width > 0 && internalVerticalGridLines > 0) {
      final double verticalStep = size.width / (internalVerticalGridLines + 1);
      for (int i = 1; i <= internalVerticalGridLines; i++) {
        final x = i * verticalStep;
        _drawDottedLine(canvas, Offset(x, 0), Offset(x, size.height), gridPaint);
      }
    }

    final double maxValue = 220.0;
    final double minValue = 0.0;
    final double range = maxValue - minValue;
    final double dx = size.width / (points.length > 1 ? points.length - 1 : 1);

    final Path path = Path();

    if (points.isNotEmpty) {
      double firstX = 0;
      double firstY = size.height - ((points[0] - minValue) / range * size.height);
      path.moveTo(firstX, firstY);

      for (int i = 0; i < points.length; i++) {
        final x = i * dx;
        final y = size.height - ((points[i] - minValue) / range * size.height);
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
