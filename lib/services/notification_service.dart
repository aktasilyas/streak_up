import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Yerel bildirim servisi — Singleton pattern
///
/// Alışkanlık hatırlatıcıları için günlük bildirimler gönderir.
/// Android 13+ (API 33) POST_NOTIFICATIONS izni yönetimi içerir.
/// zonedSchedule ile belirli saatte günlük tekrarlayan bildirim planlar.
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
  /// Timezone veritabanını da başlatır (zonedSchedule için zorunlu).
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Timezone veritabanını başlat
    tz.initializeTimeZones();
    _configureLocalTimezone();

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

  /// Yerel zaman dilimini ayarlar
  ///
  /// Cihazın UTC offset'ine göre en uygun timezone'u bulur.
  void _configureLocalTimezone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    // Bilinen timezone'lardan offset'e uyanı bul
    for (final location in tz.timeZoneDatabase.locations.values) {
      final tzNow = tz.TZDateTime.now(location);
      if (tzNow.timeZoneOffset == offset) {
        tz.setLocalLocation(location);
        debugPrint(
          'NotificationService: Timezone ayarlandı → ${location.name}',
        );
        return;
      }
    }

    // Bulunamazsa UTC kullan
    tz.setLocalLocation(tz.getLocation('UTC'));
    debugPrint('NotificationService: Timezone bulunamadı, UTC kullanılıyor');
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

  /// Her gün belirli saatte tekrarlayan bildirim planlar (zonedSchedule)
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

    // Bugünün tarihinde verilen saat:dakika ile TZDateTime oluştur
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint(
      'NotificationService: Günlük bildirim planlandı → '
      'id: $id, saat: $hour:$minute',
    );
  }

  /// Verilen saat:dakika için bir sonraki TZDateTime'ı hesaplar
  ///
  /// Eğer bugünkü saat geçtiyse yarına planlar.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Saat geçtiyse yarına planla
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
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
