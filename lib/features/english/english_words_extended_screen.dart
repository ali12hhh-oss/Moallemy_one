import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../core/audio/voice_service.dart';

class EnglishWordsExtendedScreen extends StatelessWidget {
  const EnglishWordsExtendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('English Words')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: englishWordBank.length,
        itemBuilder: (_, index) {
          final word = englishWordBank[index];
          return Card(
            child: InkWell(
              onTap: () => VoiceService.english(word['word']!),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(word['emoji']!, style: const TextStyle(fontSize: 45)),
                  Text(
                    word['word']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(word['ar']!, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
