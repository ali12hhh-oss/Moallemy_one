import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2NounVerbScreen extends StatefulWidget {
  const G2NounVerbScreen({super.key});
  @override
  State<G2NounVerbScreen> createState() => _G2NounVerbScreenState();
}

class _G2NounVerbScreenState extends State<G2NounVerbScreen> {
  final rnd = Random();
  late NounVerbWord target;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = nounVerbWords[rnd.nextInt(nounVerbWords.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceService.arabic(target.word));
  }

  void _answer(bool chosenVerb) {
    if (chosenVerb == target.isVerb) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الاسم والفعل')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('الاسم: شيء (إنسان، حيوان، غرض). الفعل: حدث يحصل (يجري، يكتب، ينام).', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => VoiceService.arabic(target.word),
                child: Column(children: [
                  Text(target.emoji, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 8),
                  Text(target.word, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
                ]),
              ),
              const SizedBox(height: 30),
              Row(children: [
                Expanded(
                  child: Button3D(
                    onTap: () => _answer(false),
                    color: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: const Center(child: Text('اسم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Button3D(
                    onTap: () => _answer(true),
                    color: const Color(0xFF00C853),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: const Center(child: Text('فعل', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
              ]),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
