import 'package:flutter/material.dart';

class SectionBackground extends StatelessWidget {
  final String asset;
  final Widget child;

  const SectionBackground({super.key, required this.asset, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover),
        Container(color: Colors.black.withValues(alpha: .16)),
        child,
      ],
    );
  }
}
