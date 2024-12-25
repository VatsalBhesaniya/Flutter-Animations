import 'package:flutter/material.dart';

class HoverAnimationScreen extends StatelessWidget {
  const HoverAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hover Animations')),
      body: const Center(
        child: HoverableCard(),
      ),
    );
  }
}

class HoverableCard extends StatefulWidget {
  const HoverableCard({super.key});

  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MouseRegion(
          onEnter: (context) => setState(() => _isHovered = true),
          onExit: (context) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: _isHovered ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
            // transform: _isHovered
            //     ? (Matrix4.identity()
            //       ..scale(1.1)
            //       ..rotateZ(0.1))
            //     : Matrix4.identity(),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ]
                  : [
                      const BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
            ),
            width: 200,
            height: 300,
            child: Center(
              child: Text(
                'Hover Me!',
                style: TextStyle(
                  color: _isHovered ? Colors.white : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // child: AnimatedDefaultTextStyle(
              //   duration: const Duration(milliseconds: 700),
              //   style: TextStyle(
              //     color: _isHovered ? Colors.white : Colors.black,
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   child: const Center(child: Text('Hover Me!')),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
