import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A chunky, playful "3D" button: a translucent colored face sits on top
/// of a darker translucent slab, allowing the page artwork to remain visible.
class Button3D extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
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

  Color get _slab => (widget.shadowColor ?? _darken(widget.color, .28)).withValues(alpha: .78);

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  void _setPressed(bool v) => setState(() => pressed = v);

  @override
  Widget build(BuildContext context) {
    final callback = widget.onTap;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: callback == null ? null : (_) => _setPressed(true),
      onTapCancel: callback == null ? null : () => _setPressed(false),
      onTapUp: callback == null ? null : (_) => _setPressed(false),
      onTap: callback == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              callback();
            },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _slab,
              borderRadius: widget.borderRadius,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            margin: EdgeInsets.only(bottom: pressed ? 0 : widget.depth),
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: .72),
              borderRadius: widget.borderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: .28),
                width: 1.4,
              ),
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
