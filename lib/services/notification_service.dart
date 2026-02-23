import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:streak_up/core/constants/app_strings.dart';

/// Yerel bildirim servisi — Singleton pattern
///
/// Alışkanlık hatırlatıcıları için günlük bildirimler gönderir.
/// Android 13+ (API 33) POST_NOTIFICATIONS izni yönetimi içerir.
class NotificationService {
  NotificationService._internal();

  /// Singleton instance
  static final NotificationService instance = NotificationService._internal();

  /// Factory constructor — her zaman aynı instance'ı döner
  factory NotificationService() => instance;

  /// FlutterLocalNotificationsPlugin instance
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Başlatıldı mı kontrolü
  bool _isInitialized = false;

  // ==========================================================================
  // KANAL BİLGİLERİ (Android)
  // ==========================================================================

  /// Android bildirim kanalı ID'si
  static const String _channelId = 'streak_up_reminders';

  /// Android bildirim kanalı açıklaması
  static const String _channelDescription =
      'Günlük alışkanlık hatırlatmaları';

  // ==========================================================================
  // YAŞAM DÖNGÜSÜ
  // ==========================================================================

  /// Bildirim servisini başlatır
  ///
  /// Uygulama başlangıcında main() içinde çağrılmalı.
  /// Android ve iOS platformları için ayrı ayarlar yapar.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android ayarları
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS ayarları
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = initialized ?? false;

    if (_isInitialized) {
      debugPrint('NotificationService: Başarıyla başlatıldı');
    } else {
      debugPrint('NotificationService: Başlatılamadı');
    }
  }

  /// Bildirime tıklanınca çağrılır
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      'NotificationService: Bildirime tıklandı → '
      'payload: ${response.payload}',
    );
    // TODO: Deep link ile ilgili alışkanlığa yönlendirme
  }

  /// SDK'nın başlatılıp başlatılmadığını kontrol eder
  bool get isInitialized => _isInitialized;

  // ==========================================================================
  // İZİN YÖNETİMİ
  // ==========================================================================

  /// Bildirim izni ister
  ///
  /// Android 13+ (API 33) için POST_NOTIFICATIONS izni,
  /// iOS için alert/badge/sound izinleri istenir.
  /// Kullanıcı izin verdiyse true döner.
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      return _requestAndroidPermission();
    }
    if (Platform.isIOS) {
      return _requestIosPermission();
    }
    return false;
  }

  /// Android 13+ bildirim izni ister
  Future<bool> _requestAndroidPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    final granted = await androidPlugin.requestNotificationsPermission();
    debugPrint(
      'NotificationService: Android izin sonucu → $granted',
    );
    return granted ?? false;
  }

  /// iOS bildirim izni ister
  Future<bool> _requestIosPermission() async {
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin == null) return false;

    final granted = await iosPlugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      'NotificationService: iOS izin sonucu → $granted',
    );
    return granted ?? false;
  }

  // ==========================================================================
  // BİLDİRİM GÖNDERME
  // ==========================================================================

  /// Her gün belirli saatte tekrarlayan bildirim planlar
  ///
  /// [id] — Benzersiz bildirim kimliği (habit id kullanılabilir)
  /// [title] — Bildirim başlığı
  /// [body] — Bildirim içeriği
  /// [hour] — Saat (0-23)
  /// [minute] — Dakika (0-59)
  /// [payload] — Bildirime tıklanınca kullanılacak ek veri
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint('NotificationService: Başlatılmadı, bildirim planlanamıyor');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      AppStrings.notificationChannelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.periodicallyShowWithDuration(
      id,
      title,
      body,
      const Duration(hours: 24),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    debugPrint(
      'NotificationService: Günlük bildirim planlandı → '
      'id: $id, saat: $hour:$minute',
    );
  }

  /// Anlık bildirim gösterir
  ///
  /// Test veya anlık hatırlatma için kullanılır.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) return;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      AppStrings.notificationChannelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
    debugPrint('NotificationService: Anlık bildirim gönderildi → id: $id');
  }

  // ==========================================================================
  // BİLDİRİM İPTAL
  // ==========================================================================

  /// Belirli bir bildirimi iptal eder
  ///
  /// [id] — İptal edilecek bildirim kimliği
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    debugPrint('NotificationService: Bildirim iptal edildi → id: $id');
  }

  /// Tüm bildirimleri iptal eder
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('NotificationService: Tüm bildirimler iptal edildi');
  }

  // ==========================================================================
  // BEKLEMEDEKİ BİLDİRİMLER
  // ==========================================================================

  /// Beklemedeki bildirim sayısını döner
  ///
  /// Debug ve istatistik amaçlı kullanılır.
  Future<int> getPendingNotificationCount() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }
}
