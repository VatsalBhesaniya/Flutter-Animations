import 'package:flutter/material.dart';

class BounceAnimationController extends StatefulWidget {
  const BounceAnimationController({super.key});

  @override
  State<BounceAnimationController> createState() => _BounceAnimationControllerState();
}

class _BounceAnimationControllerState extends State<BounceAnimationController>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _sizeAnimation = Tween<double>(
      begin: 100,
      end: 200,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (context, child) {
                return Container(
                  width: _sizeAnimation.value,
                  height: _sizeAnimation.value,
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _controller.forward();
              },
              child: const Text('Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
