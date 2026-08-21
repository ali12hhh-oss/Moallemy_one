class Pronoun {
  final String word;
  final String arabic;
  final String emoji;
  const Pronoun(this.word, this.arabic, this.emoji);
}

const englishPronouns = <Pronoun>[
  Pronoun('I', 'أنا', '🙋'),
  Pronoun('you', 'أنتَ / أنتِ', '👉'),
  Pronoun('he', 'هو', '👦'),
  Pronoun('she', 'هي', '👧'),
  Pronoun('we', 'نحن', '👨‍👩‍👧‍👦'),
  Pronoun('they', 'هم', '👥'),
  Pronoun('it', 'هو/هي (لغير العاقل)', '🐱'),
];
