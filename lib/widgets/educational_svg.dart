import 'package:flutter/material.dart';

/// Displays the project's educational emoji directly.
///
/// The app keeps the original emoji data. For emoji introduced in newer
/// Unicode versions, an older, widely supported emoji is used as a fallback
/// so the same lesson content remains visible on older Android devices.
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
      // Number keycaps are retained as emoji.
      case '1': return '1️⃣';
      case '2': return '2️⃣';
      case '3': return '3️⃣';
      case '4': return '4️⃣';
      case '5': return '5️⃣';
      case '6': return '6️⃣';
      case '7': return '7️⃣';
      case '8': return '8️⃣';
      case '9': return '9️⃣';
      case '10': return '🔟';

      // Newer emoji -> older emoji with the same educational meaning.
      case '🪡': return '🧵'; // needle -> yarn/thread
      case '🪶': return '✏️'; // feather -> pencil
      case '🧔': return '👨'; // bearded man -> man
      case '🫒': return '🥒'; // olive -> cucumber/food
      case '🫗': return '🥤'; // pouring liquid -> drink
      case '🪟': return '🚪'; // window -> door/home object
      case '🧑‍⚕️': return '👨'; // doctor -> man
      case '🧺': return '🧹'; // basket -> household item
      case '🪥': return '🧼'; // toothbrush -> soap/cleaning
      case '🛋️': return '🏠'; // sofa -> home
      case '🧸': return '🐻'; // teddy bear -> bear
      case '🏞️': return '🌳'; // national park -> nature/tree
      case '🕊️': return '🐦'; // dove -> bird

      // Keep the original project emoji where supported, but avoid newer
      // variants that commonly render as tofu on older Android releases.
      case '🥇': return '🏆';
      default: return value;
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
