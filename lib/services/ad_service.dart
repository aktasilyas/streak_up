import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob reklam servisi — Singleton pattern
///
/// Banner, interstitial ve rewarded video reklamlarını yönetir.
/// Debug modda test ID'leri, release modda gerçek ID'leri kullanır.
/// Reklam yüklenemezse UI bozulmaz (graceful degradation).
class AdService {
  AdService._internal();

  /// Singleton instance
  static final AdService instance = AdService._internal();

  /// Factory constructor — her zaman aynı instance'ı döner
  factory AdService() => instance;

  /// SDK başlatıldı mı kontrolü
  bool _isInitialized = false;

  /// Son interstitial gösterim zamanı (120s cooldown)
  DateTime? _lastInterstitialShowTime;

  /// Interstitial gösterimleri arası minimum süre (saniye)
  static const int _interstitialCooldownSeconds = 120;

  /// Yüklü interstitial reklam
  InterstitialAd? _interstitialAd;

  /// Yüklü rewarded reklam
  RewardedAd? _rewardedAd;

  // ==========================================================================
  // REKLAM ID'LERİ
  // ==========================================================================

  /// Banner reklam ID'si
  ///
  /// kDebugMode'da test ID kullanır, production'da gerçek ID
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return _testBannerAdUnitId;
    }
    // TODO: Production banner ad unit ID eklenecek
    return _testBannerAdUnitId;
  }

  /// Interstitial reklam ID'si
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return _testInterstitialAdUnitId;
    }
    // TODO: Production interstitial ad unit ID eklenecek
    return _testInterstitialAdUnitId;
  }

  /// Rewarded video reklam ID'si
  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return _testRewardedAdUnitId;
    }
    // TODO: Production rewarded ad unit ID eklenecek
    return _testRewardedAdUnitId;
  }

  // ==========================================================================
  // TEST AD UNIT ID'LERİ (Google tarafından sağlanan)
  // ==========================================================================

  static String get _testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    // iOS
    return 'ca-app-pub-3940256099942544/2934735716';
  }

  static String get _testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    // iOS
    return 'ca-app-pub-3940256099942544/4411468910';
  }

  static String get _testRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    // iOS
    return 'ca-app-pub-3940256099942544/1712485313';
  }

  // ==========================================================================
  // YAŞAM DÖNGÜSÜ
  // ==========================================================================

  /// AdMob SDK'yı başlatır
  ///
  /// Uygulama başlangıcında main() içinde çağrılmalı.
  /// Hata durumunda sessizce devam eder (graceful degradation).
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdService: SDK başarıyla başlatıldı');
    } on Exception catch (e) {
      debugPrint('AdService: SDK başlatma hatası → $e');
      // Graceful degradation — reklam gösterilmez ama uygulama çalışır
    }
  }

  /// SDK'nın başlatılıp başlatılmadığını kontrol eder
  bool get isInitialized => _isInitialized;

  // ==========================================================================
  // BANNER REKLAM
  // ==========================================================================

  /// Yeni bir banner reklam oluşturur
  ///
  /// Widget ağacında kullanmak üzere [BannerAd] döner.
  /// Yükleme başarısız olursa null döner.
  BannerAd? createBannerAd({
    AdSize size = AdSize.banner,
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    if (!_isInitialized) {
      debugPrint('AdService: SDK başlatılmadı, banner oluşturulamıyor');
      return null;
    }

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdService: Banner yüklendi');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: Banner yüklenemedi → $error');
          ad.dispose();
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
  }

  // ==========================================================================
  // INTERSTITIAL REKLAM
  // ==========================================================================

  /// Interstitial reklamı önceden yükler
  ///
  /// Gösterim anında gecikme olmaması için önceden yüklenir.
  Future<void> loadInterstitialAd() async {
    if (!_isInitialized) return;

    // Zaten yüklü bir reklam varsa tekrar yükleme
    if (_interstitialAd != null) return;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Interstitial yüklendi');
          _interstitialAd = ad;
          _setupInterstitialCallbacks(ad);
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Interstitial yüklenemedi → $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Interstitial callback'lerini ayarlar
  void _setupInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdService: Interstitial kapatıldı');
        ad.dispose();
        _interstitialAd = null;
        // Bir sonraki gösterim için önceden yükle
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Interstitial gösterilemedi → $error');
        ad.dispose();
        _interstitialAd = null;
      },
    );
  }

  /// Interstitial reklamı gösterir
  ///
  /// Cooldown süresi dolmadıysa veya reklam yüklenmediyse false döner.
  /// Başarıyla gösterildiyse true döner.
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized) return false;

    // 120 saniye cooldown kontrolü
    if (!_isInterstitialCooldownExpired) {
      debugPrint('AdService: Interstitial cooldown aktif, gösterilemiyor');
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      debugPrint('AdService: Interstitial yüklenmemiş');
      // Bir sonraki sefer için yüklemeye başla
      await loadInterstitialAd();
      return false;
    }

    await ad.show();
    _lastInterstitialShowTime = DateTime.now();
    _interstitialAd = null;
    return true;
  }

  /// Interstitial cooldown süresinin dolup dolmadığını kontrol eder
  bool get _isInterstitialCooldownExpired {
    final lastShow = _lastInterstitialShowTime;
    if (lastShow == null) return true;

    final elapsed = DateTime.now().difference(lastShow).inSeconds;
    return elapsed >= _interstitialCooldownSeconds;
  }

  // ==========================================================================
  // REWARDED VIDEO REKLAM
  // ==========================================================================

  /// Rewarded video reklamı önceden yükler
  Future<void> loadRewardedAd() async {
    if (!_isInitialized) return;

    // Zaten yüklü bir reklam varsa tekrar yükleme
    if (_rewardedAd != null) return;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Rewarded video yüklendi');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Rewarded video yüklenemedi → $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Rewarded video gösterir ve ödül kazanılıp kazanılmadığını döner
  ///
  /// Kullanıcı videoyu sonuna kadar izlerse true döner.
  /// Reklam yüklenemezse veya kullanıcı kapattıysa false döner.
  /// Streak kurtarma gibi ödüllü işlemler için kullanılır.
  Future<bool> showRewardedAd() async {
    if (!_isInitialized) return false;

    final ad = _rewardedAd;
    if (ad == null) {
      debugPrint('AdService: Rewarded video yüklenmemiş');
      await loadRewardedAd();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdService: Rewarded video kapatıldı');
        ad.dispose();
        _rewardedAd = null;
        // Ödül callback'i çalışmadıysa false döner
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        // Bir sonraki gösterim için önceden yükle
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Rewarded video gösterilemedi → $error');
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    await ad.show(
      onUserEarnedReward: (_, reward) {
        debugPrint(
          'AdService: Ödül kazanıldı → '
          '${reward.amount} ${reward.type}',
        );
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
    );

    return completer.future;
  }

  // ==========================================================================
  // TEMİZLİK
  // ==========================================================================

  /// Yüklü reklamları temizler
  ///
  /// Uygulama kapanırken çağrılmalı
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;

    _rewardedAd?.dispose();
    _rewardedAd = null;

    debugPrint('AdService: Tüm reklamlar temizlendi');
  }
}
