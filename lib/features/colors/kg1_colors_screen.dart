import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

/// Full color list for الروضة الأولى: each color shows its name clearly,
/// and an animal drawn in that same color, so the child links the color to
/// something real (أبيض → حمامة بيضاء، أسود → غراب، أخضر → ضفدع...).
class Kg1ColorsScreen extends StatefulWidget {
  const Kg1ColorsScreen({super.key});

  @override
  State<Kg1ColorsScreen> createState() => _Kg1ColorsScreenState();
}

class _ColorEntry {
  final String name;
  final Color color;
  final String animal;
  final String animalEmoji;
  const _ColorEntry(this.name, this.color, this.animal, this.animalEmoji);
}

class _Kg1ColorsScreenState extends State<Kg1ColorsScreen> {
  static const colors = <_ColorEntry>[
    _ColorEntry('أحمر', Color(0xFFE53935), 'الطماطم', '🍅'),
    _ColorEntry('أزرق', Color(0xFF1E88E5), 'الحوت', '🐋'),
    _ColorEntry('أصفر', Color(0xFFFDD835), 'الكناري', '🐤'),
    _ColorEntry('أخضر', Color(0xFF43A047), 'الضفدع', '🐸'),
    _ColorEntry('برتقالي', Color(0xFFFB8C00), 'السمكة البرتقالية', '🐠'),
    _ColorEntry('بنفسجي', Color(0xFF8E24AA), 'الأخطبوط', '🐙'),
    _ColorEntry('أبيض', Color(0xFFECEFF1), 'الحمامة', '🕊️'),
    _ColorEntry('أسود', Color(0xFF212121), 'الغراب', '🐦‍⬛'),
    _ColorEntry('بني', Color(0xFF6D4C41), 'الدب', '🐻'),
    _ColorEntry('وردي', Color(0xFFEC407A), 'الفلامنجو', '🦩'),
    _ColorEntry('رمادي', Color(0xFF9E9E9E), 'الفيل', '🐘'),
    _ColorEntry('ذهبي', Color(0xFFFFC107), 'الأسد', '🦁'),
  ];

  int? selected;

  @override
  Widget build(BuildContext context) {
    final s = selected != null ? colors[selected!] : null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الألوان 🎨')),
        body: Column(children: [
          if (s != null) _preview(s),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .85),
              itemCount: colors.length,
              itemBuilder: (_, i) {
                final c = colors[i];
                final isDark = c.color.computeLuminance() < .5;
                return Button3D(
                  onTap: () {
                    setState(() => selected = i);
                    VoiceService.arabic(c.name);
                  },
                  color: c.color,
                  padding: const EdgeInsets.all(8),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(c.animalEmoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 4),
                    Text(c.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _preview(_ColorEntry s) {
    final isDark = s.color.computeLuminance() < .5;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Text(s.animalEmoji, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 8),
        Text('اللون ${s.name}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
        Text('مثل ${s.animal}', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
      ]),
    );
  }
}
