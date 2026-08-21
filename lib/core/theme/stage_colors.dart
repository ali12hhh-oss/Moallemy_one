import 'package:flutter/material.dart';

/// Central, kid-friendly, BOLD color per learning stage so the same stage
/// always looks the same everywhere in the app (home screen buttons,
/// registration picker, stage screen header, etc.) instead of everything
/// sharing one plain theme color.
class StageColors {
  static const Map<String, Color> _colors = {
    'kg1': Color(0xFFFF6B35), // برتقالي ناري
    'kg2': Color(0xFF00BFA6), // فيروزي زاهي
    'prep': Color(0xFF7C4DFF), // بنفسجي زاهي
    'g1': Color(0xFF2979FF), // أزرق زاهي
    'g2': Color(0xFFFF1E7E), // وردي/فوشيا زاهي
    'g3': Color(0xFF00C853), // أخضر زاهي
  };

  static const Color registration = Color(0xFFFFA726); // برتقالي التسجيل
  static const Color family = Color(0xFF3D5AFE); // أزرق نيلي العائلة
  static const Color store = Color(0xFFFFC107); // ذهبي المتجر

  static Color of(String stageId) => _colors[stageId] ?? const Color(0xFF6C4CF1);
}
