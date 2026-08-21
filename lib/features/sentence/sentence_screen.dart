import 'package:flutter/material.dart';
import '../../data/content.dart';
import '../../core/audio/voice_service.dart';
class SentenceScreen extends StatefulWidget { const SentenceScreen({super.key}); @override State<SentenceScreen> createState() => _S(); }
class _S extends State<SentenceScreen> {
  int i = 0;
  @override Widget build(BuildContext c) { final s = arabicSentences[i]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('القراءة والفهم')), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
    LinearProgressIndicator(value: (i + 1) / arabicSentences.length), const SizedBox(height: 30), Card(child: Padding(padding: const EdgeInsets.all(25), child: Text(s, textAlign: TextAlign.center, style: const TextStyle(fontSize: 29, height: 1.8, fontWeight: FontWeight.bold)))),
    const SizedBox(height: 20), FilledButton.icon(onPressed: () => VoiceService.arabic(s), icon: const Icon(Icons.volume_up), label: const Text('استمع للقراءة')), const Spacer(),
    Row(children: [Expanded(child: OutlinedButton(onPressed: i == 0 ? null : () => setState(() => i--), child: const Text('السابق'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: i == arabicSentences.length - 1 ? null : () => setState(() => i++), child: const Text('التالي')))]),
  ])))); }
}
