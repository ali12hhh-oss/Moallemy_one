import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

class _Sentence {
  final String text;
  final String arabic;
  final String emoji;
  const _Sentence(this.text, this.arabic, this.emoji);
}

const _sentences = <_Sentence>[
  _Sentence('I am happy', 'أنا سعيد', '😊'),
  _Sentence('I am a student', 'أنا طالب', '🎓'),
  _Sentence('You are kind', 'أنت لطيف', '🤗'),
  _Sentence('You are my friend', 'أنت صديقي', '🤝'),
  _Sentence('He is tall', 'هو طويل', '📏'),
  _Sentence('He is a doctor', 'هو طبيب', '👨‍⚕️'),
  _Sentence('She is smart', 'هي ذكية', '🧠'),
  _Sentence('She is a teacher', 'هي معلمة', '👩‍🏫'),
  _Sentence('It is big', 'هو/هي كبير', '🐘'),
  _Sentence('It is a cat', 'إنها قطة', '🐱'),
  _Sentence('We are friends', 'نحن أصدقاء', '🤝'),
  _Sentence('We are at school', 'نحن في المدرسة', '🏫'),
  _Sentence('They are here', 'هم هنا', '📍'),
  _Sentence('They are playing', 'هم يلعبون', '⚽'),
  _Sentence('The sun is hot', 'الشمس حارة', '☀️'),
  _Sentence('The moon is bright', 'القمر مضيء', '🌙'),
];

class G3EnglishSentencesScreen extends StatelessWidget {
  const G3EnglishSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sentences 💬')),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _sentences.length,
          itemBuilder: (_, i) {
            final s = _sentences[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Button3D(
                onTap: () => VoiceService.english(s.text),
                color: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            s.arabic,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.volume_up_rounded, color: Colors.white70),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
