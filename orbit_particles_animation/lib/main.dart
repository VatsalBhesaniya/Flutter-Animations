import 'package:flutter/material.dart';
import 'package:orbit_particles_animation/orbit_particles_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Particle Orbit Animation',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const OrbitParticlesAnimation(),
    );
  }
}
