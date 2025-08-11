import 'dart:math';

import 'package:flutter/material.dart';

class CardFlipCarousel extends StatefulWidget {
  const CardFlipCarousel({super.key});

  @override
  State<CardFlipCarousel> createState() => _CardFlipCarouselState();
}

class _CardFlipCarouselState extends State<CardFlipCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.75);

  final List<Map<String, String>> items = [
    {"title": "Headphones", "price": "\$199", "icon": "🎧"},
    {"title": "Smartwatch", "price": "\$149", "icon": "⌚"},
    {"title": "Sneakers", "price": "\$89", "icon": "👟"},
    {"title": "Backpack", "price": "\$129", "icon": "🎒"},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('3D Card Flip Carousel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;
              value = index - (_pageController.page ?? 0.0);
              value = (value * 0.5).clamp(-1, 1);
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value * pi),
                alignment: Alignment.center,
                child: buildCard(index),
              );
            },
            child: buildCard(index),
          );
        },
      ),
    );
  }

  Widget buildCard(int index) {
    final item = items[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 120),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 255, 230),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item["icon"]!, style: TextStyle(fontSize: 140)),
          SizedBox(height: 20),
          Text(item["title"]!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(item["price"]!, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
