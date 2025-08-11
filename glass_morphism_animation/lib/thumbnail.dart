import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final double offset;

  BackgroundPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple, Colors.indigo, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(Offset(size.width * 0.28 + offset, size.height * 0.3), 200, paint);
    canvas.drawCircle(Offset(size.width * 0.72 - offset, size.height * 0.7), 150, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) => true;
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);

    _animation = Tween(
      begin: -150.0,
      end: 150.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(colors: [Colors.deepOrange, Colors.amber, Colors.deepPurple]),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // const Color.fromARGB(255, 0, 3, 86),
            // Colors.white70,
            // const Color.fromARGB(255, 27, 1, 72),
            Color.fromARGB(255, 2, 45, 96),
            Color.fromARGB(255, 2, 116, 155),
            Colors.white70.withValues(alpha: 0.7),
            Color.fromARGB(255, 128, 2, 238),
            Color.fromARGB(255, 38, 1, 70),
            // Color.fromARGB(255, 65, 16, 109),
            // Color.fromARGB(255, 226, 163, 1),
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(painter: BackgroundPainter(offset: _animation.value));
        },
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const GlassContainer({super.key, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          Center(
            child: GlassContainer(
              width: 1000,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Wrap content tightly
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // --- Section 1: Card Header (Large Element) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Performance Summary',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            // Small element in the header
                            Icon(Icons.dashboard, color: Colors.white, size: 28),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Section 2: Main Content Area (Text on Left, Infographics on Right) ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align top of content
                          children: [
                            // Left Column: Descriptive Text
                            Expanded(
                              flex: 3, // Takes 3 parts of the available space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This section provides a quick overview of your team\'s monthly progress. '
                                    'Understand key metrics at a glance and identify areas for improvement. '
                                    'The visual representation aims to simplify complex data into actionable insights.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 16), // Spacing after text
                                  Text(
                                    'Key Highlights:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.lime,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '➢ High completion rate indicates strong task execution.\n'
                                    '➢ Tracked work hours provide insights into effort distribution.\n'
                                    '➢ Low bug count reflects code quality and testing efficiency.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20), // Space between left and right columns
                            // Right Column: Key Metric and Smaller Metrics
                            Expanded(
                              flex: 2, // Takes 2 parts of the available space
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // Center content vertically
                                children: [
                                  // Key Metric (Very Large Element)
                                  Text(
                                    '78%', // Large percentage for overview
                                    style: TextStyle(
                                      fontSize: 54, // Slightly reduced size to fit
                                      fontWeight: FontWeight.w900,
                                      color: Colors.indigo[700],
                                    ),
                                  ),
                                  const Text(
                                    'Completion Rate', // Label for the large metric
                                    style: TextStyle(
                                      fontSize: 16, // Slightly reduced size
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ), // Spacing between percentage and small metrics
                                  // Smaller Metrics (Row of Elements)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      _buildMetricItem(
                                        icon: Icons.check_circle_outline,
                                        value: '24',
                                        label: 'Tasks Done',
                                        color: Colors.green,
                                      ),
                                      _buildMetricItem(
                                        icon: Icons.timer,
                                        value: '120h',
                                        label: 'Work Hours',
                                        color: Colors.orange,
                                      ),
                                      _buildMetricItem(
                                        icon: Icons.bug_report_outlined,
                                        value: '3',
                                        label: 'Bugs Fixed',
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24), // Space before progress bar
                        // --- Section 4: Progress Bar & Small Detail (Mix of Elements) ---
                        Text(
                          'Project Progress',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.78, // Matches 78% completion
                          backgroundColor: Colors.indigo[100],
                          color: Colors.indigo,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Last Updated: Today',
                              style: TextStyle(fontSize: 14, color: Colors.white54),
                            ),
                            Text(
                              'Target: 90%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color.darken(0.2), // Slightly darker shade for value
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}

// Extension to darken colors (for better contrast on values)
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
