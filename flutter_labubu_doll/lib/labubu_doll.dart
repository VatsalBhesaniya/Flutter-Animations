import 'package:flutter/material.dart';

class LabubuDoll extends StatefulWidget {
  const LabubuDoll({super.key});

  @override
  State<LabubuDoll> createState() => _LabubuDollState();
}

class _LabubuDollState extends State<LabubuDoll> with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);

    _blinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.yellow.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withValues(alpha: 0.3),
                  spreadRadius: 6,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _blinkAnimation,
              builder: (context, child) {
                return CustomPaint(painter: LabubuPainter(blinkValue: _blinkAnimation.value));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LabubuPainter extends CustomPainter {
  final double blinkValue;

  LabubuPainter({required this.blinkValue});

  @override
  void paint(Canvas canvas, Size size) {
    // --- Define Colors ---
    final Paint bodyPaint = Paint()..color = const Color(0xFFF788A8); // Vibrant pink for the body
    final Paint skinPaint = Paint()..color = const Color(0xFFFCD3BD); // Peach/light skin tone
    final Paint innerEarPaint = Paint()..color = const Color(0xFFF5B6CC);
    final Paint eyePaint = Paint()..color = Colors.black;
    final Paint eyeHighlightPaint = Paint()..color = Colors.white;
    final Paint mouthPaint = Paint()..color = const Color(0xFF8B0000);
    final Paint teethPaint = Paint()..color = Colors.white;
    final Paint cheekPaint = Paint()
      ..color = const Color(0xFFFF69B4).withValues(alpha: 0.7); // Hot pink for cheeks

    // --- Body ---
    final Path bodyPath = Path();
    bodyPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.62),
        const Radius.circular(70),
      ),
    );
    canvas.drawPath(bodyPath, bodyPaint);

    // --- Head (skin) ---
    final double headRadius = size.width * 0.25;
    final Offset headCenter = Offset(size.width / 2, size.height * 0.45);
    canvas.drawCircle(headCenter, headRadius, skinPaint);

    // --- Bunny Ears ---
    // Left Ear
    final Path leftEarOuterPath = Path();
    leftEarOuterPath.moveTo(headCenter.dx - headRadius * 0.6, headCenter.dy - headRadius * 0.9);
    leftEarOuterPath.quadraticBezierTo(
      headCenter.dx - headRadius * 0.9,
      headCenter.dy - headRadius * 1.8, // Control point for top curve
      headCenter.dx - headRadius * 0.3,
      headCenter.dy - headRadius * 1.9, // Top point
    );
    leftEarOuterPath.quadraticBezierTo(
      headCenter.dx + headRadius * 0.1,
      headCenter.dy - headRadius * 1.8, // Control point for bottom curve
      headCenter.dx - headRadius * 0.2,
      headCenter.dy - headRadius * 0.8, // Base of ear
    );
    leftEarOuterPath.close();
    canvas.drawPath(leftEarOuterPath, bodyPaint);

    // Right Ear
    final Path rightEarOuterPath = Path();
    rightEarOuterPath.moveTo(headCenter.dx + headRadius * 0.6, headCenter.dy - headRadius * 0.9);
    rightEarOuterPath.quadraticBezierTo(
      headCenter.dx + headRadius * 0.9,
      headCenter.dy - headRadius * 1.8, // Control point for top curve
      headCenter.dx + headRadius * 0.3,
      headCenter.dy - headRadius * 1.9, // Top point
    );
    rightEarOuterPath.quadraticBezierTo(
      headCenter.dx - headRadius * 0.1,
      headCenter.dy - headRadius * 1.8, // Control point for bottom curve
      headCenter.dx + headRadius * 0.2,
      headCenter.dy - headRadius * 0.8, // Base of ear
    );
    rightEarOuterPath.close();
    canvas.drawPath(rightEarOuterPath, bodyPaint);

    // Inner Ears
    final Path leftEarInnerPath = Path();
    leftEarInnerPath.moveTo(headCenter.dx - headRadius * 0.5, headCenter.dy - headRadius * 0.8);
    leftEarInnerPath.quadraticBezierTo(
      headCenter.dx - headRadius * 0.7,
      headCenter.dy - headRadius * 1.5,
      headCenter.dx - headRadius * 0.3,
      headCenter.dy - headRadius * 1.6,
    );
    leftEarInnerPath.quadraticBezierTo(
      headCenter.dx - headRadius * 0.05,
      headCenter.dy - headRadius * 1.5,
      headCenter.dx - headRadius * 0.2,
      headCenter.dy - headRadius * 0.7,
    );
    leftEarInnerPath.close();
    canvas.drawPath(leftEarInnerPath, innerEarPaint);

    final Path rightEarInnerPath = Path();
    rightEarInnerPath.moveTo(headCenter.dx + headRadius * 0.5, headCenter.dy - headRadius * 0.8);
    rightEarInnerPath.quadraticBezierTo(
      headCenter.dx + headRadius * 0.7,
      headCenter.dy - headRadius * 1.5,
      headCenter.dx + headRadius * 0.3,
      headCenter.dy - headRadius * 1.6,
    );
    rightEarInnerPath.quadraticBezierTo(
      headCenter.dx + headRadius * 0.05,
      headCenter.dy - headRadius * 1.5,
      headCenter.dx + headRadius * 0.2,
      headCenter.dy - headRadius * 0.7,
    );
    rightEarInnerPath.close();
    canvas.drawPath(rightEarInnerPath, innerEarPaint);

    // --- Face Features ---
    final double eyeHeight = 45 * blinkValue;
    if (eyeHeight > 0) {
      // Left Eye
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(headCenter.dx - headRadius * 0.4, headCenter.dy - headRadius * 0.2),
          width: 35,
          height: eyeHeight,
        ),
        eyePaint,
      );
      // Right Eye
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(headCenter.dx + headRadius * 0.4, headCenter.dy - headRadius * 0.2),
          width: 35,
          height: eyeHeight,
        ),
        eyePaint,
      );

      // Eye Highlights are only drawn when the eye is open
      if (blinkValue > 0.5) {
        canvas.drawCircle(
          Offset(headCenter.dx - headRadius * 0.4 + 8, headCenter.dy - headRadius * 0.2 - 10),
          5,
          eyeHighlightPaint,
        );
        canvas.drawCircle(
          Offset(headCenter.dx + headRadius * 0.4 + 8, headCenter.dy - headRadius * 0.2 - 10),
          5,
          eyeHighlightPaint,
        );
        canvas.drawCircle(
          Offset(headCenter.dx - headRadius * 0.4 - 5, headCenter.dy - headRadius * 0.2 + 8),
          3,
          eyeHighlightPaint,
        );
        canvas.drawCircle(
          Offset(headCenter.dx + headRadius * 0.4 - 5, headCenter.dy - headRadius * 0.2 + 8),
          3,
          eyeHighlightPaint,
        );
      }
    }

    // Mouth (wide and jagged)
    final Path mouthPath = Path();
    mouthPath.moveTo(headCenter.dx - headRadius * 0.5, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(headCenter.dx - headRadius * 0.4, headCenter.dy + headRadius * 0.4);
    mouthPath.lineTo(headCenter.dx - headRadius * 0.3, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(headCenter.dx - headRadius * 0.2, headCenter.dy + headRadius * 0.4);
    mouthPath.lineTo(headCenter.dx - headRadius * 0.1, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(headCenter.dx, headCenter.dy + headRadius * 0.4);
    mouthPath.lineTo(headCenter.dx + headRadius * 0.1, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(headCenter.dx + headRadius * 0.2, headCenter.dy + headRadius * 0.4);
    mouthPath.lineTo(headCenter.dx + headRadius * 0.3, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(headCenter.dx + headRadius * 0.4, headCenter.dy + headRadius * 0.4);
    mouthPath.lineTo(headCenter.dx + headRadius * 0.5, headCenter.dy + headRadius * 0.45);
    mouthPath.lineTo(
      headCenter.dx + headRadius * 0.4,
      headCenter.dy + headRadius * 0.55,
    ); // Bottom right
    mouthPath.lineTo(
      headCenter.dx - headRadius * 0.4,
      headCenter.dy + headRadius * 0.55,
    ); // Bottom left
    mouthPath.close();
    canvas.drawPath(mouthPath, mouthPaint);

    // Teeth
    final double toothWidth = 8;
    final double toothHeight = 7;
    canvas.drawRect(
      Rect.fromLTWH(
        headCenter.dx - headRadius * 0.4 + 5,
        headCenter.dy + headRadius * 0.45 + 5,
        toothWidth,
        toothHeight,
      ),
      teethPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        headCenter.dx - headRadius * 0.2 + 5,
        headCenter.dy + headRadius * 0.45 + 5,
        toothWidth,
        toothHeight,
      ),
      teethPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        headCenter.dx + headRadius * 0.0 + 5,
        headCenter.dy + headRadius * 0.45 + 5,
        toothWidth,
        toothHeight,
      ),
      teethPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        headCenter.dx + headRadius * 0.2 + 5,
        headCenter.dy + headRadius * 0.45 + 5,
        toothWidth,
        toothHeight,
      ),
      teethPaint,
    );

    // Cheeks
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(headCenter.dx - headRadius * 0.6, headCenter.dy + headRadius * 0.2),
        width: 40,
        height: 25,
      ),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(headCenter.dx + headRadius * 0.6, headCenter.dy + headRadius * 0.2),
        width: 40,
        height: 25,
      ),
      cheekPaint,
    );

    // --- Arms ---
    // Left Arm
    final Path leftArmPath = Path();
    leftArmPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.45, size.width * 0.2, size.height * 0.3),
        const Radius.circular(30),
      ),
    );
    canvas.drawPath(leftArmPath, bodyPaint);

    // Right Arm
    final Path rightArmPath = Path();
    rightArmPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.75, size.height * 0.45, size.width * 0.2, size.height * 0.3),
        const Radius.circular(30),
      ),
    );
    canvas.drawPath(rightArmPath, bodyPaint);

    // --- Legs ---
    // Left Leg
    final Path leftLegPath = Path();
    leftLegPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.8, size.width * 0.25, size.height * 0.15),
        const Radius.circular(20),
      ),
    );
    canvas.drawPath(leftLegPath, bodyPaint);

    // Right Leg
    final Path rightLegPath = Path();
    rightLegPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.8, size.width * 0.25, size.height * 0.15),
        const Radius.circular(20),
      ),
    );
    canvas.drawPath(rightLegPath, bodyPaint);

    // --- Feet (skin) ---
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.32, size.height * 0.95), width: 40, height: 25),
      skinPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.68, size.height * 0.95), width: 40, height: 25),
      skinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is LabubuPainter && oldDelegate.blinkValue != blinkValue;
  }
}
