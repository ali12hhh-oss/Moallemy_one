import 'package:flutter/material.dart';

import '../core/store/store_background_service.dart';
import '../data/store_v23.dart';

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
  String _asset;
  String _selectedId = StoreBackgroundService.originalId;

  _StoreBackgroundState() : _asset = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await StoreBackgroundService.selectedId();
    final item = _find(id);
    if (!mounted) return;
    setState(() {
      _selectedId = id;
      _asset = item?.image ?? widget.originalAsset;
    });
  }

  RewardItemV23? _find(String id) {
    for (final item in rewardsV23) {
      if (item.id == id && item.type == 'خلفيات') return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final asset = _asset.isEmpty ? widget.originalAsset : _asset;
    final overlay = widget.overlayColor ?? Colors.transparent;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            widget.originalAsset,
            fit: BoxFit.cover,
          ),
        ),
        if (overlay != Colors.transparent) ColoredBox(color: overlay),
        widget.child,
      ],
    );
  }
}
