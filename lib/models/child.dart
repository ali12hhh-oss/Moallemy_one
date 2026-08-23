class Child {
  String id, name, stage;
  int age, stars, lessons, quizzes, correct, total, minutes, streak;
  List<String> weakItems;

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
    List<String>? weakItems,
  }) : weakItems = weakItems ?? [];

  double get accuracy => total <= 0 ? 0 : (correct / total).clamp(0, 1);

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
