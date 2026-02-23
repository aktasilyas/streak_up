import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob reklam servisi — Singleton pattern
///
/// Banner, interstitial ve rewarded video reklamlarini yonetir.
/// Debug modda test ID'leri, release modda gercek ID'leri kullanir.
/// Reklam yuklenemezse UI bozulmaz (graceful degradation).
class AdService {
  AdService._internal();

  /// Singleton instance
  static final AdService instance = AdService._internal();

  /// Factory constructor — her zaman ayni instance'i doner
  factory AdService() => instance;

  /// SDK baslatildi mi?
  bool _isInitialized = false;

  /// Son interstitial gosterim zamani (120s cooldown)
  DateTime? _lastInterstitialShowTime;

  /// Interstitial gosterimleri arasi minimum sure (saniye)
  static const int _interstitialCooldownSeconds = 120;

  /// Yuklu interstitial reklam
  InterstitialAd? _interstitialAd;

  /// Yuklu rewarded reklam
  RewardedAd? _rewardedAd;

  /// SDK baslatildi mi kontrolu
  bool get isInitialized => _isInitialized;

  // --- Reklam ID'leri (kDebugMode -> test, release -> production) ---

  /// Banner reklam ID'si
  static String get bannerAdUnitId {
    if (kDebugMode) return _testBannerAdUnitId;
    // TODO: Production banner ad unit ID eklenecek
    return _testBannerAdUnitId;
  }

  /// Interstitial reklam ID'si
  static String get interstitialAdUnitId {
    if (kDebugMode) return _testInterstitialAdUnitId;
    // TODO: Production interstitial ad unit ID eklenecek
    return _testInterstitialAdUnitId;
  }

  /// Rewarded video reklam ID'si
  static String get rewardedAdUnitId {
    if (kDebugMode) return _testRewardedAdUnitId;
    // TODO: Production rewarded ad unit ID eklenecek
    return _testRewardedAdUnitId;
  }

  // Google tarafindan saglanan test ad unit ID'leri
  static String get _testBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get _testInterstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get _testRewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  /// AdMob SDK'yi baslatir
  ///
  /// Uygulama basinda main() icinde cagrilmali.
  /// Hata durumunda sessizce devam eder (graceful degradation).
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdService: SDK basariyla baslatildi');
    } on Exception catch (e) {
      debugPrint('AdService: SDK baslatma hatasi -> $e');
    }
  }

  /// Yeni bir banner reklam olusturur ve yuklemeye hazirlar
  ///
  /// Widget agacinda kullanmak uzere `BannerAd` doner.
  /// SDK baslatilmamissa null doner.
  BannerAd? loadBannerAd({
    AdSize adSize = AdSize.banner,
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    if (!_isInitialized) {
      debugPrint('AdService: SDK baslatilmadi, banner olusturulamiyor');
      return null;
    }

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdService: Banner yuklendi');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: Banner yuklenemedi -> $error');
          ad.dispose();
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
  }

  /// Interstitial reklami onceden yukler
  ///
  /// Gosterim aninda gecikme olmamasi icin onceden yuklenir.
  Future<void> loadInterstitial() async {
    if (!_isInitialized || _interstitialAd != null) return;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Interstitial yuklendi');
          _interstitialAd = ad;
          _setupInterstitialCallbacks(ad);
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Interstitial yuklenemedi -> $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Interstitial callback'lerini ayarlar
  void _setupInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Interstitial gosterilemedi -> $error');
        ad.dispose();
        _interstitialAd = null;
      },
    );
  }

  /// Interstitial reklami gosterir (120s cooldown kontrolu)
  ///
  /// Cooldown dolmadiysa veya reklam yuklenmediyse false doner.
  Future<bool> showInterstitial() async {
    if (!_isInitialized || !_isInterstitialCooldownExpired) {
      debugPrint('AdService: Interstitial gosterilemiyor (cooldown/init)');
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      debugPrint('AdService: Interstitial yuklenmemis, yukleniyor...');
      await loadInterstitial();
      return false;
    }

    await ad.show();
    _lastInterstitialShowTime = DateTime.now();
    _interstitialAd = null;
    return true;
  }

  /// Cooldown suresinin dolup dolmadigini kontrol eder
  bool get _isInterstitialCooldownExpired {
    final lastShow = _lastInterstitialShowTime;
    if (lastShow == null) return true;
    return DateTime.now().difference(lastShow).inSeconds >=
        _interstitialCooldownSeconds;
  }

  /// Rewarded video reklami onceden yukler
  Future<void> loadRewarded() async {
    if (!_isInitialized || _rewardedAd != null) return;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Rewarded video yuklendi');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Rewarded video yuklenemedi -> $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Rewarded video gosterir ve odul kazanilip kazanilmadigini doner
  ///
  /// Kullanici videoyu sonuna kadar izlerse true doner.
  /// Reklam yuklenemezse veya kullanici erken kapattiysa false doner.
  /// Streak kurtarma gibi odullu islemler icin kullanilir.
  Future<bool> showRewarded() async {
    if (!_isInitialized) return false;

    final ad = _rewardedAd;
    if (ad == null) {
      debugPrint('AdService: Rewarded video yuklenmemis');
      await loadRewarded();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) completer.complete(false);
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Rewarded gosterilemedi -> $error');
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (_, reward) {
        debugPrint(
          'AdService: Odul kazanildi -> ${reward.amount} ${reward.type}',
        );
        if (!completer.isCompleted) completer.complete(true);
      },
    );

    return completer.future;
  }

  /// Tum yuklu reklamlari temizler
  ///
  /// Uygulama kapanirken cagrilmali
  void disposeAll() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    debugPrint('AdService: Tum reklamlar temizlendi');
  }
}
