import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/audio/voice_service.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Contextual Arabic forms are used so the falling letters visually join
  // together when they settle and form the word "معلمي".
  static const _letters = <_SplashLetter>[
    _SplashLetter('مـ', Color(0xFFFF4FA3), '🐰'),
    _SplashLetter('ـعـ', Color(0xFFFFB300), '🦒'),
    _SplashLetter('ـلـ', Color(0xFF45C95A), '🐍'),
    _SplashLetter('ـمـ', Color(0xFF35A9F4), '🐘'),
    _SplashLetter('ـي', Color(0xFF9B6CFF), '🐱'),
  ];

  late final AnimationController _controller;
  Timer? _finishTimer;
  final Set<int> _playedLandingSounds = <int>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..addListener(_handleAnimationSound);
    _controller.forward();

    // Play the bundled welcome clip after the first frame. This avoids a
    // startup race with MaterialApp/AudioPlayer initialization while still
    // starting at the beginning of the splash page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(VoiceService.playWelcome());
    });

    _finishTimer = Timer(const Duration(milliseconds: 4750), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  void _handleAnimationSound() {
    for (var index = 0; index < _letters.length; index++) {
      final start = index * .13;
      final end = (.72 + index * .05).clamp(start, 1.0);
      if (_controller.value >= end - .015 &&
          !_playedLandingSounds.contains(index)) {
        _playedLandingSounds.add(index);
        SystemSound.play(SystemSoundType.click);
      }
    }
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.removeListener(_handleAnimationSound);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final letterSize = (width * .16).clamp(58.0, 92.0);

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF42B8F5),
                  Color(0xFFBCEEFF),
                  Color(0xFFE8F8C8),
                  Color(0xFF8ED35B),
                ],
                stops: [0, .48, .72, 1],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(top: 55, left: 28, child: _Cloud()),
                const Positioned(top: 120, right: 24, child: _Cloud(scale: .8)),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: height * .28,
                  child: CustomPaint(painter: _HillPainter()),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(_letters.length, (index) {
                            final start = index * .13;
                            final end = (.72 + index * .05).clamp(start, 1.0);
                            final progress = CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                start,
                                end,
                                curve: Curves.easeOutBack,
                              ),
                            ).value;

                            final drop = height * .42 * (1 - progress);
                            final scale = .72 + progress * .28;
                            return Transform.translate(
                              offset: Offset(0, -drop),
                              child: Transform.scale(
                                scale: scale,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * .002,
                                  ),
                                  child: _AnimalLetter(
                                    data: _letters[index],
                                    size: letterSize,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: height * .16,
                  child: Column(
                    children: [
                      const Text(
                        'معلمي',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              offset: Offset(0, 2),
                              color: Color(0x66000000),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 58),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              minHeight: 9,
                              value: _controller.value,
                              backgroundColor: Colors.white.withValues(alpha: .45),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF9B6CFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 38,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => Text(
                      _controller.value < .88 ? 'جاري التحميل...' : 'مرحباً بك',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SplashLetter {
  const _SplashLetter(this.letter, this.color, this.animal);
  final String letter;
  final Color color;
  final String animal;
}

class _AnimalLetter extends StatelessWidget {
  const _AnimalLetter({required this.data, required this.size});
  final _SplashLetter data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.22,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: size * .16,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: data.color,
                borderRadius: BorderRadius.circular(size * .38),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 9,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                data.letter,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: size * .66,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Text(data.animal, style: TextStyle(fontSize: size * .35)),
          ),
        ],
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({this.scale = 1});
  final double scale;

  @override
  Widget build(BuildContext context) => Transform.scale(
        scale: scale,
        child: Container(
          width: 100,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(left: 18, bottom: 7, child: _puff(30)),
              Positioned(left: 42, bottom: 10, child: _puff(42)),
              Positioned(left: 70, bottom: 7, child: _puff(28)),
            ],
          ),
        ),
      );

  Widget _puff(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .8),
          shape: BoxShape.circle,
        ),
      );
}

class _HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final back = Paint()..color = const Color(0xFFB7E989);
    final front = Paint()..color = const Color(0xFF7BCB52);
    final backPath = Path()
      ..moveTo(0, size.height * .55)
      ..quadraticBezierTo(size.width * .22, size.height * .05,
          size.width * .46, size.height * .5)
      ..quadraticBezierTo(size.width * .73, size.height * .04,
          size.width, size.height * .45)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final frontPath = Path()
      ..moveTo(0, size.height * .7)
      ..quadraticBezierTo(size.width * .28, size.height * .3,
          size.width * .55, size.height * .68)
      ..quadraticBezierTo(size.width * .78, size.height * .28,
          size.width, size.height * .62)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backPath, back);
    canvas.drawPath(frontPath, front);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
