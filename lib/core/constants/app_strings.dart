/// Uygulama genelinde kullanılan tüm metin sabitleri
///
/// Hardcoded string kullanımı yasaktır. Tüm UI metinleri bu sınıfta tanımlanmalıdır.
class AppStrings {
  AppStrings._(); // Private constructor - utility class

  // ============================================================================
  // GENEL
  // ============================================================================

  static const String appName = 'StreakUp';
  static const String appTagline = 'Alışkanlıkları Güçlendir, Hayatı Dönüştür';

  static const String ok = 'Tamam';
  static const String cancel = 'İptal';
  static const String save = 'Kaydet';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String close = 'Kapat';
  static const String back = 'Geri';
  static const String next = 'İleri';
  static const String done = 'Bitti';
  static const String skip = 'Geç';
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String retry = 'Tekrar Dene';
  static const String loading = 'Yükleniyor...';
  static const String error = 'Hata';
  static const String success = 'Başarılı';

  // ============================================================================
  // BOTTOM NAVIGATION
  // ============================================================================

  static const String navHabits = 'Alışkanlıklar';
  static const String navStatistics = 'İstatistikler';
  static const String navSettings = 'Ayarlar';

  // ============================================================================
  // HABIT LIST SCREEN
  // ============================================================================

  static const String habitListTitle = 'Alışkanlıklarım';
  static const String habitListEmptyTitle = 'Henüz alışkanlık yok';
  static const String habitListEmptyMessage =
      'İlk alışkanlığını ekleyerek streak\'ini başlat!';
  static const String habitListAddButton = 'Alışkanlık Ekle';
  static const String habitListSearchHint = 'Alışkanlık ara...';
  static const String habitListFilterAll = 'Tümü';
  static const String habitListFilterActive = 'Aktif';
  static const String habitListFilterArchived = 'Arşivlenmiş';

  static const String habitCompletedToday = 'Bugün tamamlandı';
  static const String habitNotCompletedToday = 'Bugün tamamlanmadı';
  static const String habitStreakDays = 'gün streak';
  static const String habitStreakDay = 'gün streak';

  // ============================================================================
  // HABIT FORM SCREEN
  // ============================================================================

  static const String habitFormTitleCreate = 'Yeni Alışkanlık';
  static const String habitFormTitleEdit = 'Alışkanlığı Düzenle';

  static const String habitFormNameLabel = 'Alışkanlık Adı';
  static const String habitFormNameHint = 'Örn: Sabah koşusu';
  static const String habitFormNameError = 'Alışkanlık adı boş olamaz';

  static const String habitFormDescriptionLabel = 'Açıklama (İsteğe bağlı)';
  static const String habitFormDescriptionHint = 'Neden bu alışkanlığı edinmek istiyorsun?';

  static const String habitFormIconLabel = 'İkon';
  static const String habitFormColorLabel = 'Renk';

  static const String habitFormFrequencyLabel = 'Sıklık';
  static const String habitFormFrequencyDaily = 'Her gün';
  static const String habitFormFrequencyWeekly = 'Haftanın belirli günleri';
  static const String habitFormFrequencyCustom = 'Özel';

  static const String habitFormTargetDaysLabel = 'Hedef Günler';
  static const String habitFormDayMonday = 'Pzt';
  static const String habitFormDayTuesday = 'Sal';
  static const String habitFormDayWednesday = 'Çar';
  static const String habitFormDayThursday = 'Per';
  static const String habitFormDayFriday = 'Cum';
  static const String habitFormDaySaturday = 'Cmt';
  static const String habitFormDaySunday = 'Paz';

  static const String habitFormReminderLabel = 'Hatırlatıcı';
  static const String habitFormReminderHint = 'Hatırlatma zamanı seç';
  static const String habitFormReminderNone = 'Hatırlatıcı yok';

  static const String habitFormCreateButton = 'Oluştur';
  static const String habitFormUpdateButton = 'Güncelle';
  static const String habitFormDeleteButton = 'Sil';
  static const String habitFormArchiveButton = 'Arşivle';

  static const String habitFormSuccessCreate = 'Alışkanlık oluşturuldu';
  static const String habitFormSuccessUpdate = 'Alışkanlık güncellendi';
  static const String habitFormSuccessDelete = 'Alışkanlık silindi';
  static const String habitFormSuccessArchive = 'Alışkanlık arşivlendi';

  // ============================================================================
  // HABIT DETAIL DIALOGS
  // ============================================================================

  static const String habitDeleteDialogTitle = 'Alışkanlığı Sil';
  static const String habitDeleteDialogMessage =
      'Bu alışkanlığı silmek istediğinden emin misin? Tüm geçmiş verilerin kaybolacak.';

  static const String habitArchiveDialogTitle = 'Alışkanlığı Arşivle';
  static const String habitArchiveDialogMessage =
      'Bu alışkanlığı arşivlemek istiyor musun? İstediğin zaman geri yükleyebilirsin.';

  static const String habitRestoreButton = 'Geri Yükle';
  static const String habitRestoreSuccess = 'Alışkanlık geri yüklendi';

  // ============================================================================
  // STATISTICS SCREEN
  // ============================================================================

  static const String statsTitle = 'İstatistikler';
  static const String statsEmptyTitle = 'Henüz veri yok';
  static const String statsEmptyMessage =
      'Alışkanlıklarını tamamlamaya başladığında burası grafiklerle dolacak!';

  static const String statsOverviewTitle = 'Genel Bakış';
  static const String statsTotalHabits = 'Toplam Alışkanlık';
  static const String statsActiveHabits = 'Aktif Alışkanlık';
  static const String statsCompletedToday = 'Bugün Tamamlanan';
  static const String statsCurrentStreak = 'Mevcut Streak';
  static const String statsLongestStreak = 'En Uzun Streak';
  static const String statsTotalCompletions = 'Toplam Tamamlama';

  static const String statsWeeklySummaryTitle = 'Haftalık Özet';
  static const String statsWeeklyCompletionRate = 'Tamamlanma Oranı';
  static const String statsMostProductiveDay = 'En Verimli Gün';

  static const String statsCalendarTitle = 'Takvim Görünümü';
  static const String statsCalendarHeatmapTitle = 'Aktivite Haritası';

  static const String statsStreakChartTitle = 'Streak Grafiği';
  static const String statsCompletionChartTitle = 'Tamamlama Grafiği';

  static const String statsPeriodToday = 'Bugün';
  static const String statsPeriodWeek = 'Bu Hafta';
  static const String statsPeriodMonth = 'Bu Ay';
  static const String statsPeriodYear = 'Bu Yıl';
  static const String statsPeriodAll = 'Tümü';

  static const String statsMotivationExcellent = 'Harika gidiyorsun! 🎉';
  static const String statsMotivationGood = 'İyi ilerleme kaydediyorsun! 💪';
  static const String statsMotivationNeedsWork = 'Biraz daha gayret! 🔥';
  static const String statsMotivationKeepGoing = 'Devam et, başarabilirsin! ⭐';

  static const String statsSelectHabit = 'Alışkanlık Seç';
  static const String statsAllHabits = 'Tüm Alışkanlıklar';
  static const String statsNoData = 'Henüz veri yok';
  static const String statsCompletedTasks = 'Tamamlanan Görev';
  static const String statsActiveStreakLabel = 'Aktif Streak';
  static const String statsTotalDaysLabel = 'Toplam Gün';
  static const String statsThisWeekLabel = 'Bu Hafta';

  // ============================================================================
  // SETTINGS SCREEN
  // ============================================================================

  static const String settingsTitle = 'Ayarlar';

  static const String settingsSectionAppearance = 'Görünüm';
  static const String settingsThemeMode = 'Tema';
  static const String settingsThemeLight = 'Açık';
  static const String settingsThemeDark = 'Koyu';
  static const String settingsThemeSystem = 'Sistem';

  static const String settingsSectionNotifications = 'Bildirimler';
  static const String settingsNotificationsEnabled = 'Bildirimleri Aç';
  static const String settingsNotificationsTime = 'Varsayılan Hatırlatma Saati';

  static const String settingsSectionData = 'Veri';
  static const String settingsBackupData = 'Verileri Yedekle';
  static const String settingsRestoreData = 'Verileri Geri Yükle';
  static const String settingsExportData = 'CSV Olarak Dışa Aktar';
  static const String settingsClearData = 'Tüm Verileri Temizle';

  static const String settingsSectionAbout = 'Hakkında';
  static const String settingsVersion = 'Sürüm';
  static const String settingsRateApp = 'Uygulamayı Değerlendir';
  static const String settingsShareApp = 'Uygulamayı Paylaş';
  static const String settingsPrivacyPolicy = 'Gizlilik Politikası';
  static const String settingsTermsOfService = 'Kullanım Şartları';

  static const String settingsClearDataDialogTitle = 'Verileri Temizle';
  static const String settingsClearDataDialogMessage =
      'Tüm alışkanlıkları ve geçmiş verileri silmek istediğinden emin misin? Bu işlem geri alınamaz.';

  // ============================================================================
  // ONBOARDING SCREEN
  // ============================================================================

  static const String onboardingSkip = 'Geç';
  static const String onboardingNext = 'İleri';
  static const String onboardingGetStarted = 'Başlayalım';

  static const String onboardingPage1Title = 'Hoş Geldin!';
  static const String onboardingPage1Subtitle =
      'StreakUp ile günlük alışkanlıklarını takip et ve hayalini kurduğun hayata adım adım ulaş.';

  static const String onboardingPage2Title = 'Streak\'ini Koru';
  static const String onboardingPage2Subtitle =
      'Her gün alışkanlığını tamamla, streak\'ini büyüt ve motivasyonunu yüksek tut.';

  static const String onboardingPage3Title = 'İlerlemeni Görüntüle';
  static const String onboardingPage3Subtitle =
      'Detaylı istatistikler ve grafiklerle gelişimini takip et, kendini sürekli motive et.';

  static const String onboardingPage4Title = 'Hedefine Ulaş';
  static const String onboardingPage4Subtitle =
      'Küçük adımlar, büyük değişimler. Haydi, ilk alışkanlığını oluştur!';

  // ============================================================================
  // STREAK RESCUE
  // ============================================================================

  static const String streakRescueTitle = 'Streak\'ini Kurtar';
  static const String streakRescueMessage =
      'Dün alışkanlığını tamamlamayı unuttun. Bir reklam izleyerek streak\'ini kurtarabilirsin.';
  static const String streakRescueButton = 'Reklam İzle ve Kurtar';
  static const String streakRescueSkip = 'Hayır, Kaybetsin';
  static const String streakRescueSuccess = 'Streak\'in kurtarıldı! 🎉';
  static const String streakRescueFailed = 'Reklam yüklenemedi. Lütfen tekrar dene.';
  static const String streakRescueAlreadyUsed = 'Bu günün kurtarma hakkını kullandın.';

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================

  static const String errorGeneric = 'Bir hata oluştu. Lütfen tekrar dene.';
  static const String errorNoConnection = 'İnternet bağlantısı yok.';
  static const String errorTimeout = 'İşlem zaman aşımına uğradı.';
  static const String errorNotFound = 'Bulunamadı.';
  static const String errorPermissionDenied = 'İzin verilmedi.';

  static const String errorAdNotLoaded = 'Reklam yüklenemedi.';
  static const String errorAdAlreadyShown = 'Reklam zaten gösterildi.';

  // ============================================================================
  // NOTIFICATION MESSAGES
  // ============================================================================

  static const String notificationChannelName = 'Alışkanlık Hatırlatıcıları';
  static const String notificationChannelDescription =
      'Günlük alışkanlık hatırlatmaları için bildirimler';

  static const String notificationDefaultTitle = 'Alışkanlık Zamanı!';
  static const String notificationDefaultBody = '{habitName} için seni bekliyoruz! 💪';

  static const String notificationStreakTitle = 'Streak\'ini Kaybetme!';
  static const String notificationStreakBody =
      '{habitName} için {streak} günlük streak\'ini kaybetme!';

  // ============================================================================
  // DATE / TIME
  // ============================================================================

  static const String today = 'Bugün';
  static const String yesterday = 'Dün';
  static const String tomorrow = 'Yarın';

  static const String monday = 'Pazartesi';
  static const String tuesday = 'Salı';
  static const String wednesday = 'Çarşamba';
  static const String thursday = 'Perşembe';
  static const String friday = 'Cuma';
  static const String saturday = 'Cumartesi';
  static const String sunday = 'Pazar';

  static const String january = 'Ocak';
  static const String february = 'Şubat';
  static const String march = 'Mart';
  static const String april = 'Nisan';
  static const String may = 'Mayıs';
  static const String june = 'Haziran';
  static const String july = 'Temmuz';
  static const String august = 'Ağustos';
  static const String september = 'Eylül';
  static const String october = 'Ekim';
  static const String november = 'Kasım';
  static const String december = 'Aralık';
}
