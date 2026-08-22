import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/content_v11.dart';

class MatchingGameV11 extends StatefulWidget {
  const MatchingGameV11({super.key});
  @override
  State<MatchingGameV11> createState() => _MatchingGameV11State();
}

class _MatchingGameV11State extends State<MatchingGameV11> {
  final Random _random = Random();
  late List<ArabicWordV11> cards;
  final Set<int> open = <int>{};
  final Set<int> matched = <int>{};
  int moves = 0;
  int stars = 0;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final source = [...arabicWordsV11]..shuffle(_random);
    final selected = source.take(6).toList();
    cards = [...selected, ...selected]..shuffle(_random);
    open.clear();
    matched.clear();
    moves = 0;
    stars = 0;
  }

  Future<void> _tap(int index) async {
    if (matched.contains(index) || open.contains(index) || open.length >= 2)
      return;
    setState(() => open.add(index));
    if (open.length != 2) return;
    moves++;
    final pair = open.toList();
    final correct = cards[pair[0]].word == cards[pair[1]].word;
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      if (correct) {
        matched.addAll(pair);
        stars += 2;
      }
      open.clear();
    });
    if (matched.length == cards.length && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أحسنت! أكملت لعبة المطابقة ⭐')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('طابق الكلمة والصورة')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'الحركات: $moves',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'النجوم: $stars ⭐',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => setState(_newGame),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  final visible =
                      open.contains(index) || matched.contains(index);
                  return InkWell(
                    onTap: () => _tap(index),
                    borderRadius: BorderRadius.circular(18),
                    child: Card(
                      child: Center(
                        child:
                            visible
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cards[index].emoji,
                                      style: const TextStyle(fontSize: 34),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      cards[index].word,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                                : const Text(
                                  '؟',
                                  style: TextStyle(fontSize: 40),
                                ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
