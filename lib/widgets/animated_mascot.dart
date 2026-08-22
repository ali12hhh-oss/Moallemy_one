import 'package:flutter/material.dart';

class AnimatedMascot extends StatefulWidget {
  final String asset;
  final double size;
  const AnimatedMascot({super.key, required this.asset, this.size = 86});
  @override
  State<AnimatedMascot> createState() => _AnimatedMascotState();
}

class _AnimatedMascotState extends State<AnimatedMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> floatAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat(reverse: true);
    floatAnimation = Tween<double>(
      begin: -4,
      end: 5,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: floatAnimation,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: child,
        ),
        child:
            Image.asset(widget.asset, width: widget.size, height: widget.size),
      );
}
