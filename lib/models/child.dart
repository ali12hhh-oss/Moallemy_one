class Child {
  String id, name, stage;
  int age, stars, lessons, quizzes, correct, total, minutes, streak;
  String avatarAsset, avatarPath;
  List<String> weakItems, ownedItems;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.stage,
    this.stars = 0,
    this.lessons = 0,
    this.quizzes = 0,
    this.correct = 0,
    this.total = 0,
    this.minutes = 0,
    this.streak = 0,
    this.avatarAsset = 'assets/images/child_avatars/boy_1.svg',
    this.avatarPath = '',
    List<String>? weakItems,
    List<String>? ownedItems,
  })  : weakItems = weakItems ?? [],
        ownedItems = ownedItems ?? [];

  double get accuracy => total <= 0 ? 0 : (correct / total).clamp(0, 1);

  String? get activeTitle {
    for (final item in ownedItems.reversed) {
      if (item.startsWith('title:')) return item.substring(6);
    }
    return null;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'stage': stage,
        'stars': stars,
        'lessons': lessons,
        'quizzes': quizzes,
        'correct': correct,
        'total': total,
        'minutes': minutes,
        'streak': streak,
        'weakItems': weakItems,
        'avatarAsset': avatarAsset,
        'avatarPath': avatarPath,
        'ownedItems': ownedItems,
      };

  factory Child.fromMap(Map<String, dynamic> m) => Child(
        id: m['id']?.toString() ?? '',
        name: m['name']?.toString() ?? '',
        age: _int(m['age'], 5),
        stage: m['stage']?.toString() ?? 'الروضة',
        stars: _int(m['stars']),
        lessons: _int(m['lessons']),
        quizzes: _int(m['quizzes']),
        correct: _int(m['correct']),
        total: _int(m['total']),
        minutes: _int(m['minutes']),
        streak: _int(m['streak']),
        weakItems: _strings(m['weakItems']),
        avatarAsset: m['avatarAsset']?.toString() ?? 'assets/images/child_avatars/boy_1.svg',
        avatarPath: m['avatarPath']?.toString() ?? '',
        ownedItems: _strings(m['ownedItems']),
      );

  static int _int(dynamic value, [int fallback = 0]) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static List<String> _strings(dynamic value) {
    if (value is! List) return <String>[];
    return value.map((e) => e.toString()).toList(growable: true);
  }
}
