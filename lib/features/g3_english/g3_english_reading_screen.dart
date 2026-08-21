import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class _EQuestion {
  final String question;
  final List<String> options;
  final int correct;
  const _EQuestion(this.question, this.options, this.correct);
}

const _title = 'My Day';
const _emoji = '🌞';
const _text =
    'My name is Sam. I wake up early every day. I eat breakfast with my family. '
    'Then I go to school with my friends. After school, I play in the park. '
    'At night, I read a book before I sleep. I am happy every day!';
const _questions = <_EQuestion>[
  _EQuestion('What is his name?', ['Sam', 'Ali', 'Tom'], 0),
  _EQuestion('When does he wake up?', ['At night', 'Early', 'At noon'], 1),
  _EQuestion('What does he do after school?', ['He sleeps', 'He plays in the park', 'He cooks'], 1),
];

class G3EnglishReadingScreen extends StatefulWidget {
  const G3EnglishReadingScreen({super.key});
  @override
  State<G3EnglishReadingScreen> createState() => _G3EnglishReadingScreenState();
}

class _G3EnglishReadingScreenState extends State<G3EnglishReadingScreen> {
  bool showQuestions = false;
  int questionIndex = 0;
  String? cheer;

  void _answer(int chosen) {
    if (chosen == _questions[questionIndex].correct) {
      setState(() => cheer = kCheers[questionIndex % kCheers.length]);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          cheer = null;
          if (questionIndex + 1 < _questions.length) {
            questionIndex++;
          } else {
            showQuestions = false;
            questionIndex = 0;
          }
        });
      });
    } else {
      setState(() => cheer = 'Try again 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: !showQuestions
                ? Column(children: [
                    const Text(_emoji, style: TextStyle(fontSize: 50)),
                    IconButton(icon: const Icon(Icons.volume_up_rounded), iconSize: 34, onPressed: () => VoiceService.english(_text)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(_text, style: const TextStyle(fontSize: 19, height: 1.9), textDirection: TextDirection.ltr, textAlign: TextAlign.left),
                      ),
                    ),
                    FilledButton.icon(onPressed: () => setState(() => showQuestions = true), icon: const Icon(Icons.quiz_rounded), label: const Text('Questions')),
                  ])
                : Column(children: [
                    LinearProgressIndicator(value: (questionIndex + 1) / _questions.length),
                    const SizedBox(height: 20),
                    Text(_questions[questionIndex].question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: _questions[questionIndex].options.asMap().entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Button3D(
                              onTap: () => _answer(e.key),
                              color: const Color(0xFF2979FF),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                              child: Text(e.value, style: const TextStyle(fontSize: 18, color: Colors.white), textDirection: TextDirection.ltr),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
