import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String imageTag;
  final int imageIndex;

  const DetailScreen({super.key, required this.imageTag, required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail View')),
      body: Center(
        child: Hero(
          tag: imageTag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/sample${imageIndex.toString()}.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
