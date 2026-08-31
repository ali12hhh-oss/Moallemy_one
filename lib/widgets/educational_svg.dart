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
    default:
      return _fallbackSvg(emoji, label);
  }
}

String _svg(String body) => '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">$body</svg>''';

String _fallbackSvg(String emoji, String? label) {
  return _svg('''<defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#42A5F5"/><stop offset="1" stop-color="#7E57C2"/></linearGradient></defs><rect x="2" y="2" width="20" height="20" rx="5" fill="url(#g)"/><path fill="#fff" d="M7 8h10v8H7z"/><path fill="#E3F2FD" d="M9 10h6v4H9z"/><circle cx="9" cy="16.5" r="1" fill="#fff"/><circle cx="15" cy="16.5" r="1" fill="#fff"/>''');
}
