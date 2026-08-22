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
  double get accuracy => total == 0 ? 0 : correct / total;
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
    id: m['id'] ?? '',
    name: m['name'] ?? '',
    age: m['age'] ?? 5,
    stage: m['stage'] ?? 'الروضة',
    stars: m['stars'] ?? 0,
    lessons: m['lessons'] ?? 0,
    quizzes: m['quizzes'] ?? 0,
    correct: m['correct'] ?? 0,
    total: m['total'] ?? 0,
    minutes: m['minutes'] ?? 0,
    streak: m['streak'] ?? 0,
    weakItems: List<String>.from(m['weakItems'] ?? []),
  );
}
