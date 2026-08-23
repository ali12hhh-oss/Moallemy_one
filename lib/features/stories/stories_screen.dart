import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../data/content_v11.dart';
import '../../core/audio/voice_service.dart';
import '../../widgets/speakable_text.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('القصص')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final story in stories)
              Card(child: ListTile(
                leading: Text(story['emoji']!, style: const TextStyle(fontSize: 38)),
                title: SpeakableText(story['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: SpeakableText(story['text']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(s: story['title']!, text: story['text']!, emoji: story['emoji']!))),
              )),
            for (final story in storiesV11)
              Card(child: ListTile(
                leading: Text(story.emoji, style: const TextStyle(fontSize: 38)),
                title: SpeakableText(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: SpeakableText('${story.stage} • ${story.text}', maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(s: story.title, text: story.text, emoji: story.emoji))),
              )),
          ],
        ),
      ),
    );
  }
}

class StoryPage extends StatefulWidget {
  final String s;
  final String text;
  final String emoji;

  const StoryPage({super.key, required this.s, required this.text, required this.emoji});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: SpeakableText(widget.s)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 90)),
            SpeakableText(widget.s, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SpeakableText(widget.text, style: const TextStyle(fontSize: 23, height: 1.8)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => VoiceService.arabic(widget.text),
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع إلى القصة'),
            ),
          ]),
        ),
      ),
    );
  }
}
