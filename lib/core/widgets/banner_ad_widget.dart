import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/services/ad_service.dart';

/// Banner reklam widget — StatefulWidget (reklam lifecycle icin istisna)
///
/// initState'de banner yukler, dispose'da temizler.
/// Yuklenirken bos SizedBox gosterir (layout shift onlenir).
/// Hata durumunda bos SizedBox (graceful degradation).
class BannerAdWidget extends StatefulWidget {
  /// Constructor
  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  /// Reklam boyutu
  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  /// Banner reklami yukler
  void _loadBanner() {
    final ad = AdService.instance.loadBannerAd(
      adSize: widget.adSize,
      onAdLoaded: (_) {
        if (mounted) {
          setState(() => _isLoaded = true);
        }
      },
      onAdFailedToLoad: (_, _) {
        if (mounted) {
          setState(() {
            _isLoaded = false;
            _bannerAd = null;
          });
        }
      },
    );

    if (ad != null) {
      _bannerAd = ad;
      ad.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;

    // Yuklenmediyse veya hata olduysa bos alan goster
    if (!_isLoaded || ad == null) {
      return const SizedBox(
        height: AppDimensions.bannerAdContainerHeight,
        width: double.infinity,
      );
    }

    // Yuklendiyse AdWidget goster
    return SizedBox(
      height: AppDimensions.bannerAdContainerHeight,
      width: double.infinity,
      child: AdWidget(ad: ad),
    );
  }
}
