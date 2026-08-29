import 'package:flutter/material.dart';

import 'store_background.dart';

class SectionBackground extends StatelessWidget {
  final String asset;
  final Widget child;

  const SectionBackground({
    super.key,
    required this.asset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return StoreBackground(
      originalAsset: asset,
      overlayColor: Colors.black.withValues(alpha: .06),
      child: child,
    );
  }
}
