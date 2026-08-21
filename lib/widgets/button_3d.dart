import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A chunky, playful "3D" button: a colored face sits on top of a darker
/// slab of the same hue. On press, the face drops down to meet the slab
/// (like a real button being pushed), then springs back up on release.
/// Used everywhere in the app instead of flat Material cards so every
/// tappable button feels physical and satisfying for kids.
class Button3D extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final Color? shadowColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double depth;

  const Button3D({
    super.key,
    required this.child,
    required this.onTap,
    required this.color,
    this.shadowColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.depth = 8,
  });

  @override
  State<Button3D> createState() => _Button3DState();
}

class _Button3DState extends State<Button3D> {
  bool pressed = false;

  Color get _slab => widget.shadowColor ?? _darken(widget.color, .28);

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  void _setPressed(bool v) => setState(() => pressed = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: Stack(children: [
        // The darker "slab" underneath — always full-size, never moves.
        Container(
          decoration: BoxDecoration(color: _slab, borderRadius: widget.borderRadius),
        ),
        // The bright face on top — drops down onto the slab when pressed.
        AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(bottom: pressed ? 0 : widget.depth),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: .22), width: 1.4),
          ),
          child: widget.child,
        ),
      ]),
    );
  }
}
