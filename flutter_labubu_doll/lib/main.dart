import 'package:flutter/material.dart';
import 'package:flutter_labubu_doll/thumbnail.dart';
// import 'package:flutter_labubu_doll/labubu_doll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Labubu Doll',
      // home: const LabubuDoll(),
      home: const LabubuDoll(),
    );
  }
}
