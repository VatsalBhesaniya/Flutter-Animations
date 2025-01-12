import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Animated Carousel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: const Carousel(),
    );
  }
}

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'https://cdn.pixabay.com/photo/2023/07/10/06/13/mountain-8117525_1280.jpg',
      'https://cdn.pixabay.com/photo/2023/09/22/07/02/red-8268266_1280.jpg',
      'https://cdn.pixabay.com/photo/2023/10/20/03/36/mushrooms-8328101_1280.jpg',
    ];

    return PageView.builder(
      controller: _controller,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildCarouselItem(images[index], index);
      },
    );
  }

  // Widget _buildCarouselItem(String imageUrl, int index) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 500),
  //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: _currentPage == index ? 10 : 30),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       image: DecorationImage(
  //         image: NetworkImage(imageUrl),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCarouselItem(String imageUrl, int index) {
    double scale = _currentPage == index ? 1.0 : 0.9;
    double opacity = _currentPage == index ? 1.0 : 0.4;

    return Transform.scale(
      scale: scale,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 1000),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: _currentPage == index ? 10 : 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
