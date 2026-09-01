import 'package:flutter/material.dart';

/// Displays the educational emoji supplied by the content directly.
///
/// No SVG is generated here. Existing emoji remain emoji, and newly supplied
/// emoji are displayed without adding or depending on SVG illustrations.
class EducationalSvg extends StatelessWidget {
  final String emoji;
  final double size;
  final String? label;

  const EducationalSvg({
    super.key,
    required this.emoji,
    this.size = 58,
    this.label,
  });

  String get _displayEmoji {
    final value = emoji.trim();
    switch (value) {
      case '1':
        return '1️⃣';
      case '2':
        return '2️⃣';
      case '3':
        return '3️⃣';
      case '4':
        return '4️⃣';
      case '5':
        return '5️⃣';
      case '6':
        return '6️⃣';
      case '7':
        return '7️⃣';
      case '8':
        return '8️⃣';
      case '9':
        return '9️⃣';
      case '10':
        return '🔟';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            _displayEmoji,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.72,
              height: 1.0,
              fontFamilyFallback: const [
                'Noto Color Emoji',
                'Apple Color Emoji',
                'Segoe UI Emoji',
              ],
            ),
          ),
        ),
      ),
    );
  }
}
