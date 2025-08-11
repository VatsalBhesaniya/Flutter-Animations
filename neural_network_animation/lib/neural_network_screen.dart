import 'dart:math';
import 'package:flutter/material.dart';

class Neuron {
  Offset position;
  List<Neuron> connections = [];

  Neuron(this.position);
}

class NeuralNetworkPainter extends CustomPainter {
  List<Neuron> neurons;
  double time;

  NeuralNetworkPainter(this.neurons, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint neuronPaint = Paint()..color = Colors.yellow;
    final Paint connectionPaint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.4)
      ..strokeWidth = 2;

    for (var neuron in neurons) {
      canvas.drawCircle(neuron.position, 10, neuronPaint);

      for (var connectedNeuron in neuron.connections) {
        Path path = Path();
        path.moveTo(neuron.position.dx, neuron.position.dy);
        path.quadraticBezierTo(
          (neuron.position.dx + connectedNeuron.position.dx) / 2 + sin(time) * 20,
          (neuron.position.dy + connectedNeuron.position.dy) / 2 + cos(time) * 20,
          connectedNeuron.position.dx,
          connectedNeuron.position.dy,
        );
        canvas.drawPath(path, connectionPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class NeuralNetworkScreen extends StatefulWidget {
  const NeuralNetworkScreen({super.key});

  @override
  State<NeuralNetworkScreen> createState() => _NeuralNetworkScreenState();
}

class _NeuralNetworkScreenState extends State<NeuralNetworkScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Neuron> _neurons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _neurons = List.generate(8, (index) {
      return Neuron(
        Offset(Random().nextDouble() * 300, Random().nextDouble() * 500),
      );
    });

    for (var neuron in _neurons) {
      neuron.connections = List.from(_neurons)..shuffle();
      neuron.connections = neuron.connections.sublist(0, Random().nextInt(3) + 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: NeuralNetworkPainter(_neurons, _controller.value * 2 * pi),
                size: Size.infinite,
              );
            },
          ),
        ),
      ),
    );
  }
}
