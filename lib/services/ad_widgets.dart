import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_service.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key, this.margin = const EdgeInsets.symmetric(vertical: 12)});

  final EdgeInsets margin;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _reserved = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    if (!await AdService.reserveInlineAdSlot()) return;
    _reserved = true;
    if (!mounted) {
      AdService.releaseInlineAdSlot();
      return;
    }
    final ad = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          if (!mounted) {
            ad.dispose();
            AdService.releaseInlineAdSlot();
            return;
          }
          _ad = ad as BannerAd;
          await AdService.markAdShown();
          AdService.releaseInlineAdSlot();
          _reserved = false;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          AdService.releaseInlineAdSlot();
          _reserved = false;
          if (mounted) setState(() => _loaded = false);
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    if (_reserved) AdService.releaseInlineAdSlot();
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}

class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key, this.margin = const EdgeInsets.symmetric(vertical: 12)});

  final EdgeInsets margin;

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _reserved = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    if (!await AdService.reserveInlineAdSlot()) return;
    _reserved = true;
    if (!mounted) {
      AdService.releaseInlineAdSlot();
      return;
    }
    final ad = NativeAd(
      adUnitId: AdService.nativeAdUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 14,
        mainBackgroundColor: Colors.white,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) async {
          if (!mounted) {
            ad.dispose();
            AdService.releaseInlineAdSlot();
            return;
          }
          _ad = ad as NativeAd;
          await AdService.markAdShown();
          AdService.releaseInlineAdSlot();
          _reserved = false;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          AdService.releaseInlineAdSlot();
          _reserved = false;
          if (mounted) setState(() => _loaded = false);
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    if (_reserved) AdService.releaseInlineAdSlot();
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Container(
      margin: widget.margin,
      constraints: const BoxConstraints(minHeight: 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
