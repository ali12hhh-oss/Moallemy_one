class Child {
  String id, name, stage;

  int age,
      stars,
      lessons,
      quizzes,
      correct,
      total,
      minutes,
      streak;

  /// الصورة الكرتونية المختارة للطفل من صور التطبيق.
  String avatarAsset;

  /// مسار الصورة التي اختارها المستخدم من معرض الهاتف.
  String avatarPath;

  /// مسار الصورة المستخدم في بطاقة الطفل.
  /// يبقى متوافقاً مع avatarPath حتى لا تتأثر الأجزاء القديمة.
  String imagePath;

  /// جنس الطفل: boy / girl
  String gender;

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

    this.avatarAsset =
        'assets/images/child_avatars/boy_1.svg',

    this.avatarPath = '',

    this.imagePath = '',

    this.gender = 'boy',

    List<String>? weakItems,
    List<String>? ownedItems,
  })  : weakItems = weakItems ?? <String>[],
        ownedItems = ownedItems ?? <String>[] {
    // إذا كان هناك avatarPath قديم ولم يوجد imagePath،
    // نستخدمه تلقائياً حتى تبقى البيانات القديمة متوافقة.
    if (imagePath.isEmpty && avatarPath.isNotEmpty) {
      imagePath = avatarPath;
    }

    // والعكس أيضاً للحفاظ على التوافق مع الأجزاء القديمة.
    if (avatarPath.isEmpty && imagePath.isNotEmpty) {
      avatarPath = imagePath;
    }
  }

  double get accuracy {
    if (total <= 0) return 0;
    return (correct / total).clamp(0, 1);
  }

  String? get activeTitle {
    for (final item in ownedItems.reversed) {
      if (item.startsWith('title:')) {
        return item.substring(6);
      }
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    return {
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

      // الحقول الجديدة
      'imagePath': imagePath,
      'gender': gender,

      'ownedItems': ownedItems,
    };
  }

  factory Child.fromMap(Map<String, dynamic> m) {
    final storedAvatarPath =
        m['avatarPath']?.toString() ?? '';

    final storedImagePath =
        m['imagePath']?.toString() ?? '';

    // دعم البيانات القديمة والجديدة.
    final resolvedImagePath = storedImagePath.isNotEmpty
        ? storedImagePath
        : storedAvatarPath;

    final resolvedAvatarPath = storedAvatarPath.isNotEmpty
        ? storedAvatarPath
        : storedImagePath;

    return Child(
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

      avatarAsset: m['avatarAsset']?.toString() ??
          'assets/images/child_avatars/boy_1.svg',

      avatarPath: resolvedAvatarPath,

      imagePath: resolvedImagePath,

      gender: m['gender']?.toString() ?? 'boy',

      ownedItems: _strings(m['ownedItems']),
    );
  }

  static int _int(
    dynamic value, [
    int fallback = 0,
  ]) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }

  static List<String> _strings(dynamic value) {
    if (value is! List) {
      return <String>[];
    }

    return value
        .map((e) => e.toString())
        .toList(growable: true);
  }
}
