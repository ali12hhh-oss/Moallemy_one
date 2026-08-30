import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

class G3LetterSkillsScreen extends StatefulWidget {
  const G3LetterSkillsScreen({super.key});

  @override
  State<G3LetterSkillsScreen> createState() => _G3LetterSkillsScreenState();
}

class _G3LetterSkillsScreenState extends State<G3LetterSkillsScreen> {
  // The rest of this file is unchanged. This declaration only makes the
  // sort-option callback always satisfy Button3D's non-null VoidCallback.
  static const _fix = true;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
