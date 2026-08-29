import 'package:flutter/material.dart';

import '../core/store/store_background_service.dart';
import '../data/store_v23.dart';
import '../features/shop/store_artwork.dart';

class StoreBackground extends StatefulWidget {
  final Widget child;
  final String originalAsset;
  final Color? overlayColor;

  const StoreBackground({
    super.key,
    required this.child,
    required this.originalAsset,
    this.overlayColor,
  });

  @override
  State<StoreBackground> createState() => _StoreBackgroundState();
}

class _StoreBackgroundState extends State<StoreBackground> {
  RewardItemV23? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await StoreBackgroundService.selectedId();
    RewardItemV23? selected;
    if (id != StoreBackgroundService.originalId) {
      for (final item in rewardsV23) {
        if (item.id == id && item.type == 'خلفيات') {
          selected = item;
          break;
        }
      }
    }
    if (!mounted) return;
    setState(() => _selected = selected);
  }

  @override
  Widget build(BuildContext context) {
    final background = _selected == null
        ? Image.asset(
            widget.originalAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: Theme.of(context).colorScheme.surface,
            ),
          )
        : StoreArtwork(art: _selected!.art, background: true);
    final overlay = widget.overlayColor;
    return Stack(
      fit: StackFit.expand,
      children: [
        background,
        if (overlay != null) ColoredBox(color: overlay),
        widget.child,
      ],
    );
  }
}
