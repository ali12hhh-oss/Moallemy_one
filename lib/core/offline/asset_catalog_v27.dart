
class AssetCatalogV27 {
  static const arabicLetters = <String>[
    'أ','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','و','ي'
  ];
  static const englishLetters = <String>[
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
  ];
  static String arabicImage(String letter) => 'assets/images/arabic/${letter.runes.first}.svg';
  static String arabicAudio(String letter) => 'assets/audio/arabic/${letter.runes.first}.wav';
  static String englishImage(String letter) => 'assets/images/english/$letter.svg';
  static String englishAudio(String letter) => 'assets/audio/english/${letter.toLowerCase()}.wav';
}
