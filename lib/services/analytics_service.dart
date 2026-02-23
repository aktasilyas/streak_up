import 'package:flutter/foundation.dart';

// TODO: Firebase Analytics aktifleştirildiğinde aşağıdaki import açılacak
// import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics servisi — Singleton pattern
///
/// Kullanıcı davranışlarını ve ekran görüntülemelerini loglar.
/// Şimdilik debugPrint ile çalışır, Firebase entegrasyonuna hazır altyapı.
/// AdService ve NotificationService ile aynı Singleton yapısını kullanır.
class AnalyticsService {
  AnalyticsService._internal();

  /// Singleton instance
  static final AnalyticsService instance = AnalyticsService._internal();

  /// Factory constructor — her zaman aynı instance'ı döner
  factory AnalyticsService() => instance;

  // TODO: Firebase Analytics aktifleştirildiğinde kullanılacak
  // late final FirebaseAnalytics _analytics;

  /// Başlatıldı mı kontrolü
  bool _isInitialized = false;

  /// SDK'nın başlatılıp başlatılmadığını kontrol eder
  bool get isInitialized => _isInitialized;

  // ==========================================================================
  // YAŞAM DÖNGÜSÜ
  // ==========================================================================

  /// Analytics servisini başlatır
  ///
  /// Firebase aktifleştirilene kadar sadece debug logları kullanılır.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // TODO: Firebase Analytics aktifleştirildiğinde:
    // _analytics = FirebaseAnalytics.instance;

    _isInitialized = true;
    debugPrint('AnalyticsService: Başarıyla başlatıldı (debug modu)');
  }

  // ==========================================================================
  // OLAY LOGLAMA
  // ==========================================================================

  /// Özel bir olayı loglar
  ///
  /// [name] — Olay adı (ör: 'habit_created', 'streak_rescued')
  /// [parameters] — Ek parametreler (ör: {'habit_id': 1, 'frequency': 'daily'})
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    debugPrint(
      'AnalyticsService: Event → $name'
      '${parameters != null ? ', params: $parameters' : ''}',
    );

    // TODO: Firebase Analytics aktifleştirildiğinde:
    // await _analytics.logEvent(name: name, parameters: parameters);
  }

  // ==========================================================================
  // EKRAN GÖRÜNTÜLEME
  // ==========================================================================

  /// Ekran görüntüleme olayını loglar
  ///
  /// [screenName] — Ekran adı (ör: 'habit_list', 'statistics')
  Future<void> logScreenView(String screenName) async {
    debugPrint('AnalyticsService: Screen → $screenName');

    // TODO: Firebase Analytics aktifleştirildiğinde:
    // await _analytics.logScreenView(screenName: screenName);
  }

  // ==========================================================================
  // KULLANICI ÖZELLİKLERİ
  // ==========================================================================

  /// Kullanıcı özelliği ayarlar
  ///
  /// [name] — Özellik adı (ör: 'theme_mode', 'notification_enabled')
  /// [value] — Özellik değeri (ör: 'dark', 'true')
  Future<void> setUserProperty(String name, String value) async {
    debugPrint('AnalyticsService: UserProperty → $name = $value');

    // TODO: Firebase Analytics aktifleştirildiğinde:
    // await _analytics.setUserProperty(name: name, value: value);
  }

  // ==========================================================================
  // ÖN TANIMLI OLAYLAR
  // ==========================================================================

  /// Alışkanlık oluşturma olayını loglar
  Future<void> logHabitCreated({
    required String habitName,
    required String frequency,
  }) async {
    await logEvent('habit_created', parameters: {
      'habit_name': habitName,
      'frequency': frequency,
    });
  }

  /// Alışkanlık tamamlama olayını loglar
  Future<void> logHabitCompleted({required int habitId}) async {
    await logEvent('habit_completed', parameters: {
      'habit_id': habitId,
    });
  }

  /// Streak kurtarma olayını loglar
  Future<void> logStreakRescued({required int habitId}) async {
    await logEvent('streak_rescued', parameters: {
      'habit_id': habitId,
    });
  }

  /// Reklam gösterim olayını loglar
  Future<void> logAdShown({required String adType}) async {
    await logEvent('ad_shown', parameters: {
      'ad_type': adType,
    });
  }
}
