import 'package:flutter/material.dart';

class FlipCardScreen extends StatefulWidget {
  const FlipCardScreen({super.key});

  @override
  State<FlipCardScreen> createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 800),
    // );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D Flip Animation")),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective effect
                  ..rotateY(_animation.value * 3.14), // Rotate around Y-axis
                child: _animation.value < 0.5 ? _buildFrontCard() : _buildBackCard(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    // return _buildCard("Front Side", Colors.blue);
    return _buildCard("assets/images/car_front.jpg");
  }

  Widget _buildBackCard() {
    // return Transform(
    //   alignment: Alignment.center,
    //   transform: Matrix4.identity()..rotateY(3.14), // Flip the back side
    //   child: _buildCard("Back Side", Colors.red),
    // );
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14), // Flip the back side
      child: _buildCard("assets/images/car_back.jpg"),
    );
  }

  // Widget _buildCard(String text, Color color) {
  //   return Container(
  //     width: 200,
  //     height: 300,
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
  //     ),
  //     alignment: Alignment.center,
  //     child: Text(
  //       text,
  //       style: const TextStyle(fontSize: 22, color: Colors.white),
  //     ),
  //   );
  // }

  Widget _buildCard(String assetImage) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetImage), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
