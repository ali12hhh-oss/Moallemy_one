import 'package:flutter/material.dart';
import '../../data/content.dart';
import '../../core/audio/voice_service.dart';
class LettersScreen extends StatefulWidget { const LettersScreen({super.key}); @override State<LettersScreen> createState() => _S(); }
class _S extends State<LettersScreen> {
  int i = 0;
  String _letterName(String x) => const {'أ':'ألف','ب':'باء','ت':'تاء','ث':'ثاء','ج':'جيم','ح':'حاء','خ':'خاء','د':'دال','ذ':'ذال','ر':'راء','ز':'زاي','س':'سين','ش':'شين','ص':'صاد','ض':'ضاد','ط':'طاء','ظ':'ظاء','ع':'عين','غ':'غين','ف':'فاء','ق':'قاف','ك':'كاف','ل':'لام','م':'ميم','ن':'نون','ه':'هاء','و':'واو','ي':'ياء'}[x] ?? x;
  @override Widget build(BuildContext c) {
    final l = arabicLetters[i];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الحروف العربية')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      LinearProgressIndicator(value: (i + 1) / arabicLetters.length), const SizedBox(height: 12), Text('الحرف ${i + 1} من ${arabicLetters.length}'), const SizedBox(height: 10),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        Text(l.letter, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold)), Text('صوت الحرف: ${l.sound}', style: const TextStyle(fontSize: 25)), Text('اسم الحرف: ${_letterName(l.letter)}', style: const TextStyle(fontSize: 20)), Text('${l.emoji}  ${l.word}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound), icon: const Icon(Icons.volume_up), label: const Text('استمع إلى صوت الحرف')),
        OutlinedButton.icon(onPressed: () => VoiceService.arabic(l.word), icon: const Icon(Icons.record_voice_over), label: const Text('استمع إلى الكلمة')),
        OutlinedButton.icon(onPressed: () => VoiceService.arabic(_letterName(l.letter)), icon: const Icon(Icons.badge), label: const Text('اسم الحرف')),
      ]))),
      const Spacer(), Row(children: [Expanded(child: OutlinedButton(onPressed: i == 0 ? null : () => setState(() => i--), child: const Text('السابق'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: i == arabicLetters.length - 1 ? null : () => setState(() => i++), child: const Text('التالي')))]),
    ]))));
  }
}
