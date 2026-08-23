import 'package:flutter/material.dart';

import '../core/audio/voice_service.dart';

/// Text that the child can tap to hear the exact educational content.
///
/// For a single Arabic letter the central audio service plays the phoneme,
/// not the letter name. For words, sentences, numbers and maths it uses TTS.
class SpeakableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticLabel;
  final String? language;
  final bool enabled;

  const SpeakableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticLabel,
    this.language,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticLabel,
    );

    if (!enabled || text.trim().isEmpty) return child;

    return Semantics(
      button: true,
      label: semanticLabel ?? text,
      hint: 'اضغط للاستماع',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => VoiceService.speak(text, language: language),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: child,
        ),
      ),
    );
  }
}
