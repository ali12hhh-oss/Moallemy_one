import 'package:flutter/material.dart';

import '../../core/learning/adaptive_learning_engine_v9.dart';
import '../../core/localization/arabic_numbers.dart';

class SkillPracticeScreenV9 extends StatefulWidget {
  final String stageId;
  final String skill;
  final String question;
  final List<String> options;
  final String answer;

  const SkillPracticeScreenV9({
    super.key,
    required this.stageId,
    required this.skill,
    required this.question,
    required this.options,
    required this.answer,
  });

  @override
  State<SkillPracticeScreenV9> createState() => _SkillPracticeScreenV9State();
}

class _SkillPracticeScreenV9State extends State<SkillPracticeScreenV9> {
  bool? result;
  int attempts = 0;
  int correct = 0;

  Future<void> _answer(String option) async {
    if (result != null) return;
    final ok = option == widget.answer;
    await AdaptiveLearningEngineV9.recordAnswer(
      stageId: widget.stageId,
      skill: widget.skill,
      correct: ok,
    );
    if (!mounted) return;
    setState(() {
      result = ok;
      attempts++;
      if (ok) correct++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('تدريب ${widget.skill}')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text(
                widget.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...widget.options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () => _answer(option),
                      child: Text(option, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    result! ? '🎉 إجابة صحيحة' : '🔄 نراجعها مرة أخرى',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (attempts > 0)
                Text('إجابات صحيحة: ${arNum(correct)} من ${arNum(attempts)}'),
            ],
          ),
        ),
      ),
    );
  }
}
