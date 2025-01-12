import 'package:flutter/material.dart';

class GradientLoadingAnimation extends StatefulWidget {
  const GradientLoadingAnimation({super.key});

  @override
  State<GradientLoadingAnimation> createState() => _GradientLoadingAnimationState();
}

class _GradientLoadingAnimationState extends State<GradientLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                Colors.lightBlue.withAlpha(40),
                Colors.deepPurple,
                Colors.blueAccent.withAlpha(100),
              ],
              // stops: [
              //   _controller.value - 0.3,
              //   _controller.value,
              //   _controller.value + 0.3,
              // ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(rect);
          },
          child: child,
        );
      },
      child: _buildLoadingShape(),
    );
  }

  Widget _buildLoadingShape() {
    // return Container(
    //   width: 100,
    //   height: 100,
    //   decoration: const BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: Colors.white,
    //   ),
    // );
    return Container(
      width: 150,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
    );
  }
}
