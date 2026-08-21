import 'package:flutter/material.dart';
class MenuCard extends StatelessWidget {
  final String title, subtitle, emoji, image; final VoidCallback onTap;
  const MenuCard({super.key, required this.title, required this.subtitle, required this.emoji, required this.image, required this.onTap});
  @override Widget build(BuildContext context) => Semantics(button: true, label: '$title، $subtitle', child: Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Padding(padding: const EdgeInsets.all(14), child: Row(textDirection: TextDirection.rtl, children: [
    ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(image, width: 76, height: 58, fit: BoxFit.cover, errorBuilder: (context, error, stack) => Container(width: 76, height: 58, color: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(Icons.image_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant)))), const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$emoji  $title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 14))])),
    const Icon(Icons.chevron_left_rounded),
  ])))));
}
