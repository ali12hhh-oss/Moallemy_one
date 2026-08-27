class AssetCatalogV27 {
  static const arabicLetters = <String>[
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
    'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي',
  ];
  static const englishLetters = <String>[
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  ];
  static String arabicImage(String letter) =>
      'assets/images/arabic/${letter.runes.first}.svg';
  static String arabicAudio(String letter) =>
      'assets/audio/arabic/${letter.runes.first}.wav';
  static String englishImage(String letter) =>
      'assets/images/english/$letter.svg';
  static String englishAudio(String letter) {
    const replacementFiles = <String, String>{
      'e': 'En-us-e.ogg',
      'f': 'En-us-f.ogg',
      'i': 'En-us-i.ogg',
      'l': 'l.mp3',
      'n': 'En-us-n.ogg',
      'q': 'En-us-q.ogg',
      'r': 'En-us-r.ogg',
      's': 'En-us-s.ogg',
      'u': 'En-us-u.ogg',
      'v': 'En-us-v.ogg',
      'x': 'En-us-x.ogg',
    };
    final value = letter.toLowerCase();
    return 'assets/audio/en/${replacementFiles[value] ?? '$value.wav'}';
  }
}
