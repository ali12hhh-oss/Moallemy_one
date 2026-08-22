import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../data/content_v11.dart';
import '../../core/audio/voice_service.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القصص')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final story in stories)
              Card(
                child: ListTile(
                  leading: Text(
                    story['emoji']!,
                    style: const TextStyle(fontSize: 38),
                  ),
                  title: Text(
                    story['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    story['text']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryPage(
                        s: story['title']!,
                        text: story['text']!,
                        emoji: story['emoji']!,
                      ),
                    ),
                  ),
                ),
              ),
            for (final story in storiesV11)
              Card(
                child: ListTile(
                  leading: Text(
                    story.emoji,
                    style: const TextStyle(fontSize: 38),
                  ),
                  title: Text(
                    story.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${story.stage} • ${story.text}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryPage(
                        s: story.title,
                        text: story.text,
                        emoji: story.emoji,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StoryPage extends StatelessWidget {
  final String s;
  final String text;
  final String emoji;

  const StoryPage({
    super.key,
    required this.s,
    required this.text,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(s)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 90)),
              Text(
                s,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(text, style: const TextStyle(fontSize: 23, height: 1.8)),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => VoiceService.arabic(text),
                icon: const Icon(Icons.volume_up),
                label: const Text('استمع إلى القصة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
