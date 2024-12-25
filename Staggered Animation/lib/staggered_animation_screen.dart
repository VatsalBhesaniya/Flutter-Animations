import 'package:flutter/material.dart';

class StaggeredAnimationScreen extends StatefulWidget {
  const StaggeredAnimationScreen({super.key});

  @override
  State<StaggeredAnimationScreen> createState() => _StaggeredAnimationScreenState();
}

class _StaggeredAnimationScreenState extends State<StaggeredAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staggered Animations')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) => _buildAnimatedBox(index)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.forward(from: 0.0);
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildAnimatedBox(int index) {
    final delay = index * 0.1; // Stagger by 200ms for each box.
    final animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delay, delay + 0.6, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - animation.value) * 50),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                width: 100,
                height: 100,
                color: Colors.blueAccent,
              ),
            ),
          ),
          // child: Transform.rotate(
          //   angle: animation.value * 2 * 3.14, // Full rotation
          //   child: Center(
          //     child: Container(
          //       margin: const EdgeInsets.symmetric(vertical: 8.0),
          //       width: 100,
          //       height: 100,
          //       color: Colors.blueAccent,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
