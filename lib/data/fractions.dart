/// كسور أساسية للصف الثالث: نصف، ربع، ثلث — تُعرض بصريًا كأجزاء ملوّنة من
/// دائرة كاملة.
class FractionItem {
  final String name;
  final int denominator; // 2 = نصف، 3 = ثلث، 4 = ربع
  final String symbol; // ١/٢ إلخ
  const FractionItem(this.name, this.denominator, this.symbol);
}

const fractions = <FractionItem>[
  FractionItem('نصف', 2, '½'),
  FractionItem('ثلث', 3, '⅓'),
  FractionItem('ربع', 4, '¼'),
];
