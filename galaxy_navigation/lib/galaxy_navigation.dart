import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GalaxyNavigation extends StatefulWidget {
  const GalaxyNavigation({super.key});
  @override
  State<GalaxyNavigation> createState() => _GalaxyNavigationState();
}

class _GalaxyNavigationState extends State<GalaxyNavigation> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;
  late final DateTime _startTime;
  Offset _camera = Offset.zero;
  Offset _cameraVel = Offset.zero;

  final List<Planet> _planets = [
    Planet(
      name: 'Mercury',
      color: const Color(0xFFB2B2B2),
      size: 10,
      orbitRadius: 80,
      orbitSpeed: 1.8,
      icon: Icons.bolt,
      info: 'Smallest planet. Fast orbit.',
    ),
    Planet(
      name: 'Venus',
      color: const Color(0xFFE3C07B),
      size: 14,
      orbitRadius: 120,
      orbitSpeed: 1.3,
      icon: Icons.spa,
      info: 'Thick atmosphere. Hottest surface.',
    ),
    Planet(
      name: 'Earth',
      color: const Color(0xFF50B4FF),
      size: 15,
      orbitRadius: 160,
      orbitSpeed: 1.0,
      icon: Icons.public,
      info: 'Our blue marble. Life confirmed!',
    ),
    Planet(
      name: 'Mars',
      color: const Color(0xFFE66B6B),
      size: 12,
      orbitRadius: 200,
      orbitSpeed: 0.8,
      icon: Icons.landscape,
      info: 'The red planet. Future outpost?',
    ),
    Planet(
      name: 'Jupiter',
      color: const Color(0xFFF2D2A9),
      size: 26,
      orbitRadius: 260,
      orbitSpeed: 0.45,
      icon: Icons.wind_power,
      info: 'Gas giant. Great Red Spot.',
    ),
    Planet(
      name: 'Saturn',
      color: const Color(0xFFEFD8A5),
      size: 24,
      orbitRadius: 320,
      orbitSpeed: 0.35,
      icon: Icons.rowing,
      info: 'Iconic rings. Stunning view.',
    ),
    Planet(
      name: 'Uranus',
      color: const Color(0xFF9CE7EA),
      size: 18,
      orbitRadius: 370,
      orbitSpeed: 0.25,
      icon: Icons.ac_unit,
      info: 'Icy giant. Spins on its side.',
    ),
    Planet(
      name: 'Neptune',
      color: const Color(0xFF4BA3F2),
      size: 18,
      orbitRadius: 420,
      orbitSpeed: 0.2,
      icon: Icons.water,
      info: 'Deep blue. Fastest winds.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _ticker = createTicker((dt) {
      final elapsed = DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
      _t = elapsed * 0.1;

      // Decay camera velocity for drag inertia
      _camera += _cameraVel;
      _cameraVel *= 0.90;
      if (_cameraVel.distance < 0.02) _cameraVel = Offset.zero;
      // Gently spring back to origin
      _camera = Offset(lerpDouble(_camera.dx, 0, 0.02)!, lerpDouble(_camera.dy, 0, 0.02)!);

      if (mounted) setState(() {});
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final center = size.center(Offset.zero) + _camera * 0.6;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (d) {
          _camera += d.delta;
          _cameraVel = d.delta;
        },
        child: Stack(
          children: [
            // Deep space gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFF03060E), Color(0xFF070B17), Color(0xFF060911)],
                    radius: 1.2,
                    center: Alignment(0.0, -0.3),
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Starfield
            Positioned.fill(
              child: CustomPaint(
                painter: StarfieldPainter(time: _t, parallax: _camera),
              ),
            ),

            // Sun (glow)
            Positioned.fill(
              child: CustomPaint(
                painter: SunPainter(center: center, time: _t),
              ),
            ),

            // Orbits
            Positioned.fill(
              child: CustomPaint(
                painter: OrbitPainter(center: center, planets: _planets),
              ),
            ),

            // Planets (as widgets so we can use Hero + gestures)
            ..._planets.map((p) {
              final angle = (_t * p.orbitSpeed * 2 * pi) % (2 * pi);
              final pos = center + Offset(cos(angle), sin(angle)) * p.orbitRadius.toDouble();

              return Positioned(
                left: pos.dx - p.size,
                top: pos.dy - p.size,
                child: Hero(
                  tag: 'planet:${p.name}',
                  flightShuttleBuilder: (ctx, anim, dir, fromCtx, toCtx) {
                    // Make flight look like glowing sphere
                    final t = CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic);
                    return AnimatedBuilder(
                      animation: t,
                      builder: (_, __) {
                        final glow =
                            12.0 +
                            18.0 * (dir == HeroFlightDirection.push ? t.value : (1 - t.value));
                        return _PlanetWidget(planet: p, glow: glow);
                      },
                    );
                  },
                  child: GestureDetector(
                    onTap: () => _openPlanet(p, center, pos),
                    child: _PlanetWidget(planet: p),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openPlanet(Planet p, Offset center, Offset planetPos) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => PlanetDetailsPage(planet: p),
        transitionsBuilder: (context, animation, secondary, child) {
          // Subtle fly-through: scale + fade background
          final scale = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          final fade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }
}

class _PlanetWidget extends StatelessWidget {
  final Planet planet;
  final double glow;
  const _PlanetWidget({required this.planet, this.glow = 10});

  @override
  Widget build(BuildContext context) {
    final double size = planet.size * 2.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Planet body via radial gradient for 3D-ish look
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.9),
            planet.color,
            Color.lerp(planet.color, Colors.black, 0.65)!,
          ],
          stops: const [0.0, 0.3, 1.0],
          center: const Alignment(-0.4, -0.4),
        ),
        boxShadow: [
          BoxShadow(color: planet.color.withValues(alpha: 0.25), blurRadius: glow, spreadRadius: 1),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 0.5),
      ),
      child: Center(
        child: Icon(
          planet.icon,
          size: planet.size * 0.9,
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class PlanetDetailsPage extends StatefulWidget {
  final Planet planet;
  const PlanetDetailsPage({super.key, required this.planet});

  @override
  State<PlanetDetailsPage> createState() => _PlanetDetailsPageState();
}

class _PlanetDetailsPageState extends State<PlanetDetailsPage> with SingleTickerProviderStateMixin {
  late final AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.planet;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // Space backdrop
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF050A14), Color(0xFF0B1427)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: StarfieldPainter(time: _cardController.value * 12.0, parallax: Offset.zero),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Center hero planet
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.14),
              child: Hero(
                tag: 'planet:${p.name}',
                child: _PlanetWidget(planet: p, glow: 22),
              ),
            ),
          ),

          // Morphing card (circle -> rounded panel)
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _cardController,
              builder: (_, __) {
                final t = Curves.easeInOutCubic.transform(_cardController.value);
                final h = lerpDouble(300, 360, t)!;
                final r = lerpDouble(100, 22, t)!;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        height: h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.10),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1),
                        ),
                        child: _PlanetInfo(planet: p, progress: t),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanetInfo extends StatelessWidget {
  final Planet planet;
  final double progress; // 0..1
  const _PlanetInfo({required this.planet, required this.progress});

  @override
  Widget build(BuildContext context) {
    final appear = CurvedAnimation(parent: AlwaysStoppedAnimation(progress), curve: Curves.easeOut);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: appear.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planet.name,
              style: TextStyle(color: planet.color, fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Text(planet.info, style: TextStyle(color: Colors.white, fontSize: 16)),
            const Spacer(),
            _Chip(icon: Icons.circle_outlined, label: 'Orbit Radius: ${planet.orbitRadius}'),
            const SizedBox(height: 8),
            _Chip(
              icon: Icons.timeline,
              label: 'Orbit: ${(planet.orbitSpeed * 100).toStringAsFixed(0)}%',
            ),
            const SizedBox(height: 8),
            _Chip(icon: Icons.incomplete_circle_outlined, label: 'Size: ${planet.size}'),
            const Spacer(),
            Center(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.explore),
                label: const Text('Explore'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class Planet {
  final String name;
  final Color color;
  final int size;
  final int orbitRadius;
  final double orbitSpeed;
  final IconData icon;
  final String info;
  const Planet({
    required this.name,
    required this.color,
    required this.size,
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.icon,
    required this.info,
  });
}

class StarfieldPainter extends CustomPainter {
  final double time;
  final Offset parallax;
  StarfieldPainter({required this.time, required this.parallax});

  @override
  void paint(Canvas canvas, Size size) {
    // Three parallax layers
    _paintLayer(
      canvas,
      size,
      density: 0.0016,
      speed: 6,
      blur: 6,
      opacity: 0.55,
      parallaxFactor: 0.40,
      seed: 11,
    );
    _paintLayer(
      canvas,
      size,
      density: 0.0011,
      speed: 4,
      blur: 4,
      opacity: 0.70,
      parallaxFactor: 0.25,
      seed: 29,
    );
    _paintLayer(
      canvas,
      size,
      density: 0.0008,
      speed: 2,
      blur: 2,
      opacity: 0.90,
      parallaxFactor: 0.12,
      seed: 71,
    );
  }

  void _paintLayer(
    Canvas canvas,
    Size size, {
    required double density,
    required double speed,
    required double blur,
    required double opacity,
    required double parallaxFactor,
    required int seed,
  }) {
    final rnd = Random(seed);
    final count = max(60, (size.width * size.height * density).toInt());
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur.toDouble());

    // Drift horizontally a little to feel alive
    final drift = sin(time / 2) * 20.0;

    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;

      // Parallax offset
      final p =
          Offset(x, y) +
          parallax * parallaxFactor +
          Offset(drift + (i % 7) * (time * speed % 1), 0);

      final r = (rnd.nextDouble() * 1.6) + 0.4;
      canvas.drawCircle(p, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.parallax != parallax;
}

class OrbitPainter extends CustomPainter {
  final Offset center;
  final List<Planet> planets;
  OrbitPainter({required this.center, required this.planets});

  @override
  void paint(Canvas canvas, Size size) {
    final orbitPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final p in planets) {
      canvas.drawCircle(center, p.orbitRadius.toDouble(), orbitPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.planets != planets;
}

class SunPainter extends CustomPainter {
  final Offset center;
  final double time;
  SunPainter({required this.center, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final sunRadius = 42.0;
    // Glow pulse
    final pulse = (sin(time * 2) * 0.5 + 0.5) * 0.25 + 0.75;
    final glowShader = RadialGradient(
      colors: [
        const Color(0xFFFFE08A).withValues(alpha: 0.85),
        const Color(0xFFFFA726).withValues(alpha: 0.8),
        Colors.transparent,
      ],
      stops: const [0.0, 0.35, 1.0],
      center: const Alignment(-0.2, -0.2),
      radius: 1.0,
    ).createShader(Rect.fromCircle(center: center, radius: sunRadius * 4));

    // Core
    final coreShader = RadialGradient(
      colors: [const Color(0xFFFFF3B0), const Color(0xFFFFC46B), const Color(0xFFE07B39)],
      stops: const [0.0, 0.5, 1.0],
      center: const Alignment(-0.2, -0.2),
      radius: 1.0,
    ).createShader(Rect.fromCircle(center: center, radius: sunRadius));

    canvas.drawCircle(
      center,
      sunRadius * 3 * pulse,
      Paint()
        ..shader = glowShader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
    );
    canvas.drawCircle(
      center,
      sunRadius,
      Paint()
        ..shader = coreShader
        ..imageFilter = ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant SunPainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.time != time;
}
