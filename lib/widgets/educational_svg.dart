import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders educational illustrations as local SVG vectors instead of relying
/// on the Android system emoji font. This keeps the illustrations visible on
/// older Android versions as well.
class EducationalSvg extends StatelessWidget {
  final String emoji;
  final double size;
  final String? label;

  const EducationalSvg({
    super.key,
    required this.emoji,
    this.size = 58,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svgFor(emoji, label: label),
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: label,
    );
  }
}

String _svgFor(String emoji, {String? label}) {
  switch (emoji) {
    case '🏠':
      return _svg('''<path fill="#FF7043" d="M12 2 2.8 9.5v11.7h18.4V9.5L12 2Z"/><path fill="#FFE0B2" d="M6 10.2 12 5.3l6 4.9v8.2H6z"/><path fill="#42A5F5" d="M10 14h4v4h-4z"/>''');
    case '🚪':
      return _svg('''<rect x="5" y="3" width="14" height="18" rx="1.5" fill="#8D6E63"/><rect x="7" y="5" width="10" height="14" rx="1" fill="#A1887F"/><circle cx="14.5" cy="12" r="1" fill="#FFD54F"/>''');
    case '🪑':
      return _svg('''<path fill="#FFB74D" d="M5 10h14v5H5z"/><path fill="#F57C00" d="M6 15h2v6H6zm10 0h2v6h-2z"/><path fill="#FFE0B2" d="M7 5h10v6H7z"/>''');
    case '🪟':
      return _svg('''<rect x="3" y="4" width="18" height="16" rx="2" fill="#90CAF9" stroke="#1565C0" stroke-width="2"/><path stroke="#1565C0" stroke-width="2" d="M12 4v16M3 12h18"/><path stroke="#E3F2FD" stroke-width="2" d="m5 7 5 3M14 14l5 3"/>''');
    case '🛏️':
      return _svg('''<path fill="#42A5F5" d="M3 12h18v7H3z"/><path fill="#1976D2" d="M4 8h4a3 3 0 0 1 3 3v1H4z"/><path fill="#FFE0B2" d="M5 9h5v3H5z"/><path fill="#90CAF9" d="M11 10h9v2h-9z"/><path fill="#5D4037" d="M3 19h2v3H3zm16 0h2v3h-2z"/>''');
    case '🚌':
      return _svg('''<rect x="3" y="4" width="18" height="14" rx="3" fill="#42A5F5"/><rect x="5" y="6" width="14" height="6" rx="1" fill="#E3F2FD"/><circle cx="7" cy="19" r="2" fill="#424242"/><circle cx="17" cy="19" r="2" fill="#424242"/><path fill="#FFD54F" d="M5 13h3v2H5zm11 0h3v2h-3z"/>''');
    case '🚗':
      return _svg('''<path fill="#EF5350" d="M5 15 7 9h10l3 6v4H5z"/><path fill="#90CAF9" d="m8 10 1-2h6l2 2z"/><circle cx="8" cy="19" r="2" fill="#424242"/><circle cx="17" cy="19" r="2" fill="#424242"/><circle cx="6" cy="16" r="1" fill="#FFF59D"/>''');
    case '🦁':
      return _svg('''<circle cx="12" cy="12" r="9" fill="#FFB300"/><circle cx="12" cy="12" r="6.5" fill="#FFE082"/><circle cx="9.5" cy="11" r="1"/><circle cx="14.5" cy="11" r="1"/><path d="M10 14q2 2 4 0" fill="none" stroke="#6D4C41" stroke-width="1.5" stroke-linecap="round"/>''');
    case '🐰':
    case '🐇':
      return _svg('''<ellipse cx="8" cy="6" rx="2.5" ry="5" fill="#F8BBD0"/><ellipse cx="16" cy="6" rx="2.5" ry="5" fill="#F8BBD0"/><circle cx="12" cy="13" r="7" fill="#FAFAFA"/><circle cx="9.5" cy="12" r="1"/><circle cx="14.5" cy="12" r="1"/><path d="M10 15q2 2 4 0" fill="none" stroke="#E57373" stroke-width="1.4"/>''');
    case '🐱':
      return _svg('''<path fill="#FFB74D" d="m5 8 2-5 4 3 2-1 4-2 2 5v7a7 7 0 0 1-14 0z"/><circle cx="9.5" cy="13" r="1"/><circle cx="14.5" cy="13" r="1"/><path d="M10 16q2 1.5 4 0" fill="none" stroke="#6D4C41" stroke-width="1.4"/>''');
    case '🐶':
      return _svg('''<path fill="#A1887F" d="M6 8 4 4l4 1 4-2 4 2 4-1-2 4v7a6 6 0 0 1-12 0z"/><circle cx="9.5" cy="13" r="1"/><circle cx="14.5" cy="13" r="1"/><ellipse cx="12" cy="16" rx="2" ry="1.5" fill="#424242"/>''');
    case '🐟':
      return _svg('''<path fill="#42A5F5" d="M3 12q5-7 14-3l4-3v12l-4-3q-9 4-14-3z"/><circle cx="9" cy="10" r="1" fill="#263238"/><path d="M14 10q2 2 0 4" fill="none" stroke="#E3F2FD" stroke-width="1.2"/>''');
    case '🐦':
      return _svg('''<path fill="#42A5F5" d="M5 15q0-8 8-8 5 0 7 4-2 7-9 7-4 0-6-3z"/><circle cx="16" cy="10" r="1" fill="#263238"/><path fill="#FFB300" d="m20 11 3 1-3 2z"/><path fill="#1976D2" d="m8 12 4 2-4 2z"/>''');
    case '🌳':
      return _svg('''<path fill="#795548" d="M10 13h4v8h-4z"/><circle cx="12" cy="8" r="6" fill="#43A047"/><circle cx="7" cy="11" r="4" fill="#66BB6A"/><circle cx="17" cy="11" r="4" fill="#388E3C"/>''');
    case '🌸':
      return _svg('''<path stroke="#66BB6A" stroke-width="2" d="M12 12v9"/><circle cx="12" cy="9" r="3" fill="#F48FB1"/><circle cx="8" cy="9" r="3" fill="#F06292"/><circle cx="16" cy="9" r="3" fill="#F06292"/><circle cx="12" cy="5" r="3" fill="#F8BBD0"/><circle cx="12" cy="9" r="1.5" fill="#FFD54F"/>''');
    case '☀️':
      return _svg('''<circle cx="12" cy="12" r="5" fill="#FFD54F"/><g stroke="#FFB300" stroke-width="2" stroke-linecap="round"><path d="M12 2v3M12 19v3M2 12h3M19 12h3M5 5l2 2M17 17l2 2M19 5l-2 2M7 17l-2 2"/></g>''');
    case '🌙':
      return _svg('''<path fill="#5C6BC0" d="M18 4a8 8 0 1 0 1 13 7 7 0 0 1-1-13z"/><circle cx="7" cy="6" r="1" fill="#FFD54F"/><circle cx="5" cy="15" r="1" fill="#FFD54F"/>''');
    case '⚽':
      return _svg('''<circle cx="12" cy="12" r="9" fill="#FAFAFA" stroke="#455A64" stroke-width="1.5"/><path fill="#263238" d="m12 7 3 2-1 3h-4l-1-3z"/><path stroke="#455A64" stroke-width="1.2" fill="none" d="m9 9-3-2m8 0 3-3m0 6 3 2m-7 0-2 4m6-4 2 4"/>''');
    case '✏️':
      return _svg('''<path fill="#FFD54F" d="m5 17 2-7 9-7 4 4-9 9z"/><path fill="#EF5350" d="m16 3 4 4 1-1-4-4z"/><path fill="#8D6E63" d="m5 17-1 4 4-1z"/><path fill="#90CAF9" d="m8 10 5 5-2 2-5-5z"/>''');
    case '📖':
      return _svg('''<path fill="#42A5F5" d="M3 5q5-2 9 1v15q-4-3-9-1zM21 5q-5-2-9 1v15q4-3 9-1z"/><path stroke="#1565C0" stroke-width="1.5" d="M12 6v15"/>''');
    case '📚':
      return _svg('''<rect x="4" y="5" width="4" height="14" rx="1" fill="#EF5350" transform="rotate(-8 4 5)"/><rect x="8" y="4" width="5" height="15" rx="1" fill="#42A5F5" transform="rotate(3 8 4)"/><rect x="13" y="6" width="5" height="13" rx="1" fill="#66BB6A" transform="rotate(8 13 6)"/>''');
    case '🍎':
      return _svg('''<path fill="#EF5350" d="M12 20C5 20 3 14 5 9c1-3 4-4 7-2 3-2 6-1 7 2 2 5 0 11-7 11z"/><path fill="#66BB6A" d="M12 6q1-4 5-4-1 4-5 4z"/>''');
    case '🍌':
      return _svg('''<path fill="#FFD54F" d="M5 5q2 11 12 12 3 0 4-2-2 6-8 5C7 19 3 12 5 5z"/><path fill="#8D6E63" d="M5 4h3v2H5z"/>''');
    case '🍊':
      return _svg('''<circle cx="12" cy="13" r="8" fill="#FF9800"/><path fill="#66BB6A" d="M12 5q2-3 5-2-1 3-5 3z"/><path fill="#F57C00" d="M9 8q3-2 6 0" fill="none" stroke="#F57C00"/>''');
    case '🍇':
      return _svg('''<g fill="#7E57C2"><circle cx="9" cy="10" r="3"/><circle cx="15" cy="10" r="3"/><circle cx="7" cy="14" r="3"/><circle cx="12" cy="14" r="3"/><circle cx="17" cy="14" r="3"/><circle cx="10" cy="18" r="3"/><circle cx="15" cy="18" r="3"/></g><path fill="#66BB6A" d="M12 7q1-4 5-3-1 3-5 4z"/>''');
    case '🥛':
      return _svg('''<path fill="#E3F2FD" stroke="#42A5F5" stroke-width="1.5" d="M6 5h12l-1 15H7z"/><path fill="#42A5F5" d="M6 5h12v3H6z"/><path fill="#90CAF9" d="M8 11h8v3H8z"/>''');
    case '🍞':
      return _svg('''<path fill="#FFB74D" d="M5 20V9q0-5 7-5t7 5v11z"/><path fill="#FFE0B2" d="M7 10q1-3 5-3t5 3z"/>''');
    case '🥕':
      return _svg('''<path fill="#FF7043" d="M8 8q4-2 9 1l-6 11q-5 0-3-12z"/><path fill="#66BB6A" d="M8 8 5 3l2-1 3 5 1-6 2 1-1 6 4-4 1 2-5 5z"/>''');
    case '🌊':
      return _svg('''<path fill="#29B6F6" d="M2 9q3-4 6 0t6 0 6 0 2 0v9H2z"/><path fill="#81D4FA" d="M2 14q3-4 6 0t6 0 6 0 2 0v4H2z"/>''');
    case '⭐':
      return _svg('''<path fill="#FFD54F" stroke="#FFB300" d="m12 3 2.7 5.5 6.1.9-4.4 4.3 1 6.1-5.4-2.9-5.4 2.9 1-6.1-4.4-4.3 6.1-.9z"/>''');
    case '🔑':
      return _svg('''<circle cx="8" cy="12" r="4" fill="#FFD54F" stroke="#F9A825" stroke-width="2"/><path fill="#FFD54F" d="M11 11h10v3h-3v3h-3v-3h-4z"/>''');
    case '🧁':
      return _svg('''<path fill="#FFB74D" d="M6 10h12l-1 10H7z"/><path fill="#F48FB1" d="M5 10q0-4 3-4 1-3 4-1 3-2 4 1 3 0 3 4z"/><circle cx="9" cy="7" r="1" fill="#FFD54F"/><circle cx="15" cy="6" r="1" fill="#FFD54F"/>''');

    // English curriculum emoji not present in the original SVG map.
    case '🎂':
      return _svg('''<path fill="#F48FB1" d="M4 11h16v9H4z"/><path fill="#FFCC80" d="M4 9q0-3 4-3 2-3 4 0 2-3 4 0 4 0 4 3v3H4z"/><path fill="#EF5350" d="M6 11h12v2H6z"/><path fill="#FFD54F" d="M7 4h2v4H7zm8 0h2v4h-2z"/>''');
    case '🐘':
      return _svg('''<path fill="#90A4AE" d="M5 17V9q0-5 7-5t7 6v7h-4v-5h-3v5z"/><path fill="#90A4AE" d="M18 11q4 0 3 4-1 2-3 1v-2q1 0 1-1t-1-1z"/><circle cx="10" cy="8" r="1" fill="#263238"/>''');
    case '🐐':
      return _svg('''<path fill="#EEEEEE" d="M5 17q0-7 7-7t7 7v3H5z"/><path fill="#BDBDBD" d="M8 11 6 5l2 1 2 3zm8 0 2-6-2 1-2 4z"/><circle cx="10" cy="13" r="1"/><circle cx="15" cy="13" r="1"/><path d="M10 16q2 1 4 0" fill="none" stroke="#616161" stroke-width="1.2"/>''');
    case '🐎':
      return _svg('''<path fill="#8D6E63" d="M7 19q-2-7 2-11 2-3 6-2l3 3-2 3v7h-3v-5h-4v5z"/><path fill="#6D4C41" d="M15 7q3-3 5 0l-2 2z"/><circle cx="17" cy="10" r="1" fill="#263238"/>''');
    case '🐒':
      return _svg('''<circle cx="7" cy="11" r="3" fill="#A1887F"/><circle cx="17" cy="11" r="3" fill="#A1887F"/><circle cx="12" cy="12" r="7" fill="#8D6E63"/><ellipse cx="12" cy="15" rx="4" ry="3" fill="#BCAAA4"/><circle cx="9.5" cy="11" r="1"/><circle cx="14.5" cy="11" r="1"/>''');
    case '🐑':
      return _svg('''<circle cx="12" cy="13" r="7" fill="#FAFAFA"/><circle cx="7" cy="12" r="3" fill="#EEEEEE"/><circle cx="17" cy="12" r="3" fill="#EEEEEE"/><path fill="#424242" d="M16 9q5 1 3 6l-4-1z"/><circle cx="17" cy="11" r=".8" fill="#fff"/>''');
    case '🐯':
      return _svg('''<circle cx="12" cy="12" r="9" fill="#FFB300"/><path stroke="#5D4037" stroke-width="1.5" d="M7 7l3 3m7-3-3 3M6 13h4m8 0h-4M8 17l3-2m5 2-3-2"/><circle cx="9" cy="11" r="1"/><circle cx="15" cy="11" r="1"/>''');
    case '🦓':
      return _svg('''<path fill="#FAFAFA" stroke="#424242" stroke-width="1.5" d="M6 18V9q0-4 6-4t6 4v9z"/><path stroke="#424242" stroke-width="1.5" d="M8 7l3 3m-4 1 4 2m4-6-3 3m4 1-4 2m-3 5v-3m5 3v-3"/><circle cx="10" cy="10" r=".8"/><circle cx="15" cy="10" r=".8"/>''');
    case '🔵':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#42A5F5" stroke="#1565C0" stroke-width="1.5"/>''');
    case '🟢':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#66BB6A" stroke="#2E7D32" stroke-width="1.5"/>''');
    case '🟠':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#FF9800" stroke="#EF6C00" stroke-width="1.5"/>''');
    case '🟣':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#AB47BC" stroke="#6A1B9A" stroke-width="1.5"/>''');
    case '🔴':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#EF5350" stroke="#C62828" stroke-width="1.5"/>''');
    case '⚪':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#FAFAFA" stroke="#90A4AE" stroke-width="1.5"/>''');
    case '🟡':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#FFD54F" stroke="#F9A825" stroke-width="1.5"/>''');
    case '⚫':
      return _svg('''<circle cx="12" cy="12" r="8" fill="#263238" stroke="#000000" stroke-width="1.5"/>''');
    case '📘':
      return _svg('''<path fill="#42A5F5" d="M4 4h12q4 0 4 4v12H8q-4 0-4-4z"/><path fill="#E3F2FD" d="M7 7h9v8H7z"/><path stroke="#1565C0" stroke-width="1.2" d="M8 10h7m-7 2h6"/>''');
    case '🖊️':
      return _svg('''<path fill="#1565C0" d="m5 18 2-7 9-7 3 3-9 9z"/><path fill="#90CAF9" d="m8 11 5 5-2 2-5-5z"/><path fill="#EF5350" d="m16 4 3 3 1-1-3-3z"/>''');
    case '🧑‍🏫':
      return _svg('''<circle cx="12" cy="6" r="3" fill="#FFCCBC"/><path fill="#5D4037" d="M9 6q0-4 3-4t3 4z"/><path fill="#42A5F5" d="M7 11q5-3 10 0l2 10H5z"/><path fill="#FFCCBC" d="M6 12h3v2H6zm9 0h3v2h-3z"/><path stroke="#1565C0" stroke-width="1.5" d="M17 10v-4h4"/>''');
    case '🧒':
      return _svg('''<circle cx="12" cy="7" r="4" fill="#FFCCBC"/><path fill="#5D4037" d="M8 6q1-5 4-5t4 5q-4-2-8 0z"/><path fill="#66BB6A" d="M7 12q5-3 10 0l2 9H5z"/><circle cx="10.5" cy="7" r=".7"/><circle cx="13.5" cy="7" r=".7"/>''');
    case '👩':
      return _svg('''<circle cx="12" cy="7" r="4" fill="#FFCCBC"/><path fill="#5D4037" d="M7 8q-1-6 5-7 6 1 5 7l-2-3q-3 2-6 0z"/><path fill="#F48FB1" d="M7 12q5-3 10 0l2 9H5z"/>''');
    case '👨':
      return _svg('''<circle cx="12" cy="7" r="4" fill="#FFCCBC"/><path fill="#424242" d="M7 7q0-5 5-5t5 5l-2-2q-3 1-6 0z"/><path fill="#42A5F5" d="M7 12q5-3 10 0l2 9H5z"/>''');
    case '👧':
      return _svg('''<circle cx="12" cy="7" r="4" fill="#FFCCBC"/><path fill="#5D4037" d="M7 9Q5 2 12 2t5 7l-2-3q-3 2-6 0z"/><path fill="#AB47BC" d="M7 12q5-3 10 0l2 9H5z"/>''');
    case '👦':
      return _svg('''<circle cx="12" cy="7" r="4" fill="#FFCCBC"/><path fill="#5D4037" d="M8 6q1-4 4-4t4 4q-4-1-8 0z"/><path fill="#29B6F6" d="M7 12q5-3 10 0l2 9H5z"/>''');
    case '✈️':
      return _svg('''<path fill="#90CAF9" stroke="#1565C0" stroke-width="1" d="M3 12h7l4-7 2 1-2 6h5q2 0 2 2t-2 2h-5l2 6-2 1-4-7H3l3-2z"/>''');
    case '🚆':
      return _svg('''<rect x="4" y="4" width="16" height="14" rx="3" fill="#42A5F5"/><rect x="6" y="6" width="5" height="5" fill="#E3F2FD"/><rect x="13" y="6" width="5" height="5" fill="#E3F2FD"/><circle cx="8" cy="19" r="2" fill="#424242"/><circle cx="16" cy="19" r="2" fill="#424242"/><path stroke="#1565C0" stroke-width="2" d="M8 14h8"/>''');
    case '💧':
      return _svg('''<path fill="#42A5F5" d="M12 3q7 8 7 12a7 7 0 1 1-14 0q0-4 7-12z"/><path fill="#BBDEFB" d="M9 12q2-3 4-4-1 4-4 6z"/>''');
    case '☁️':
      return _svg('''<path fill="#90CAF9" d="M6 18h12a4 4 0 0 0 0-8 6 6 0 0 0-11-1 4 4 0 0 0-1 9z"/>''');
    case '😊':
      return _svg('''<circle cx="12" cy="12" r="9" fill="#FFD54F"/><circle cx="9" cy="10" r="1" fill="#5D4037"/><circle cx="15" cy="10" r="1" fill="#5D4037"/><path d="M8 14q4 4 8 0" fill="none" stroke="#5D4037" stroke-width="1.5" stroke-linecap="round"/>''');
    case '😢':
      return _svg('''<circle cx="12" cy="12" r="9" fill="#FFD54F"/><circle cx="9" cy="10" r="1" fill="#5D4037"/><circle cx="15" cy="10" r="1" fill="#5D4037"/><path fill="#42A5F5" d="M9 12q-1 3 0 4t1-3zM15 12q-1 3 0 4t1-3z"/><path d="M9 17q3-2 6 0" fill="none" stroke="#5D4037" stroke-width="1.5"/>''');
    case '🐘':
      return _svg('''<path fill="#90A4AE" d="M5 17V9q0-5 7-5t7 6v7h-4v-5h-3v5z"/><path fill="#90A4AE" d="M18 11q4 0 3 4-1 2-3 1v-2q1 0 1-1t-1-1z"/><circle cx="10" cy="8" r="1" fill="#263238"/>''');
    case '🐭':
      return _svg('''<circle cx="7" cy="8" r="3" fill="#B0BEC5"/><circle cx="17" cy="8" r="3" fill="#B0BEC5"/><circle cx="12" cy="13" r="7" fill="#90A4AE"/><circle cx="9.5" cy="12" r="1"/><circle cx="14.5" cy="12" r="1"/><circle cx="12" cy="15" r="1" fill="#EF9A9A"/>''');
    case '🔥':
      return _svg('''<path fill="#FF7043" d="M12 22q-7-3-6-9 1-5 5-8 0 4 2 5 1-4 4-6 2 7 1 10-1 6-6 8z"/><path fill="#FFD54F" d="M12 19q-3-2-2-5 1-2 2-3 1 2 2 3 1-2 2-3 1 5-4 8z"/>''');
    case '🧊':
      return _svg('''<path fill="#90CAF9" stroke="#42A5F5" d="m7 5 10 2 2 11-10 2-3-10z"/><path stroke="#E3F2FD" stroke-width="1.5" d="m9 8 7 2m-6 6 6-3"/>''');
    default:
      return _fallbackSvg(emoji, label);
  }
}

String _svg(String body) => '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">$body</svg>''';

String _fallbackSvg(String emoji, String? label) {
  return _svg('''<defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#42A5F5"/><stop offset="1" stop-color="#7E57C2"/></linearGradient></defs><rect x="2" y="2" width="20" height="20" rx="5" fill="url(#g)"/><path fill="#fff" d="M7 8h10v8H7z"/><path fill="#E3F2FD" d="M9 10h6v4H9z"/><circle cx="9" cy="16.5" r="1" fill="#fff"/><circle cx="15" cy="16.5" r="1" fill="#fff"/>''');
}
