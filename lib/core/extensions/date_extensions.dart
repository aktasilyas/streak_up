import 'package:streak_up/core/constants/app_strings.dart';

/// DateTime için yardımcı extension metodları
///
/// Tarih karşılaştırma, formatlama ve hesaplama işlemlerini kolaylaştırır
extension DateExtensions on DateTime {
  // ==========================================================================
  // COMPARISON
  // ==========================================================================

  /// Bugün mü?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Dün mü?
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Yarın mı?
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Belirtilen tarih ile aynı gün mü?
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Belirtilen tarih ile aynı hafta mı?
  bool isSameWeek(DateTime other) {
    final startOfThisWeek = startOfWeek;
    final startOfOtherWeek = other.startOfWeek;
    return startOfThisWeek.isSameDay(startOfOtherWeek);
  }

  /// Belirtilen tarih ile aynı ay mı?
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Belirtilen tarih ile aynı yıl mı?
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// Geçmiş tarih mi?
  bool get isPast => isBefore(DateTime.now());

  /// Gelecek tarih mi?
  bool get isFuture => isAfter(DateTime.now());

  // ==========================================================================
  // DATE ONLY (Saat bilgisi olmadan)
  // ==========================================================================

  /// Sadece tarih kısmını döndürür (saat bilgisi silinir)
  ///
  /// 2025-02-23 14:30:00 → 2025-02-23 00:00:00
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  /// İki tarih arasındaki gün farkı (mutlak değer)
  int daysBetween(DateTime other) {
    final from = toDateOnly();
    final to = other.toDateOnly();
    return (to.difference(from).inHours / 24).round().abs();
  }

  /// İki tarih arasındaki gün farkı (işaretli)
  ///
  /// Pozitif: other gelecekte, Negatif: other geçmişte
  int daysUntil(DateTime other) {
    final from = toDateOnly();
    final to = other.toDateOnly();
    return (to.difference(from).inHours / 24).round();
  }

  // ==========================================================================
  // WEEK CALCULATIONS
  // ==========================================================================

  /// Haftanın başlangıç günü (Pazartesi)
  DateTime get startOfWeek {
    final daysFromMonday = (weekday - DateTime.monday) % 7;
    return subtract(Duration(days: daysFromMonday)).toDateOnly();
  }

  /// Haftanın bitiş günü (Pazar)
  DateTime get endOfWeek {
    final daysUntilSunday = (DateTime.sunday - weekday) % 7;
    return add(Duration(days: daysUntilSunday)).toDateOnly();
  }

  /// Haftanın kaçıncı günü (1 = Pazartesi, 7 = Pazar)
  int get weekdayNumber => weekday;

  /// Pazartesi mi?
  bool get isMonday => weekday == DateTime.monday;

  /// Salı mı?
  bool get isTuesday => weekday == DateTime.tuesday;

  /// Çarşamba mı?
  bool get isWednesday => weekday == DateTime.wednesday;

  /// Perşembe mi?
  bool get isThursday => weekday == DateTime.thursday;

  /// Cuma mı?
  bool get isFriday => weekday == DateTime.friday;

  /// Cumartesi mi?
  bool get isSaturday => weekday == DateTime.saturday;

  /// Pazar mı?
  bool get isSunday => weekday == DateTime.sunday;

  /// Hafta sonu mu? (Cumartesi veya Pazar)
  bool get isWeekend => isSaturday || isSunday;

  /// Hafta içi mi? (Pazartesi - Cuma)
  bool get isWeekday => !isWeekend;

  // ==========================================================================
  // MONTH CALCULATIONS
  // ==========================================================================

  /// Ayın başlangıç günü
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Ayın bitiş günü
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0);
  }

  /// Ayın kaç gün olduğu
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  // ==========================================================================
  // YEAR CALCULATIONS
  // ==========================================================================

  /// Yılın başlangıç günü
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  /// Yılın bitiş günü
  DateTime get endOfYear {
    return DateTime(year, 12, 31);
  }

  /// Artık yıl mı?
  bool get isLeapYear {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  // ==========================================================================
  // FORMATTING
  // ==========================================================================

  /// Formatlı string döndürür
  ///
  /// Örnek: 23 Şubat 2025
  String toFormattedString() {
    final monthName = _getMonthName(month);
    return '$day $monthName $year';
  }

  /// Kısa formatlı string döndürür
  ///
  /// Örnek: 23.02.2025
  String toShortString() {
    final monthStr = month.toString().padLeft(2, '0');
    final dayStr = day.toString().padLeft(2, '0');
    return '$dayStr.$monthStr.$year';
  }

  /// ISO 8601 date only format
  ///
  /// Örnek: 2025-02-23
  String toIsoDateString() {
    final monthStr = month.toString().padLeft(2, '0');
    final dayStr = day.toString().padLeft(2, '0');
    return '$year-$monthStr-$dayStr';
  }

  /// Relative string döndürür
  ///
  /// Bugün, Dün, Yarın veya formatlı tarih
  String toRelativeString() {
    if (isToday) return AppStrings.today;
    if (isYesterday) return AppStrings.yesterday;
    if (isTomorrow) return AppStrings.tomorrow;
    return toFormattedString();
  }

  /// Saat formatı
  ///
  /// Örnek: 14:30
  String toTimeString() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Tam tarih saat formatı
  ///
  /// Örnek: 23 Şubat 2025 14:30
  String toFullString() {
    return '${toFormattedString()} ${toTimeString()}';
  }

  // ==========================================================================
  // WEEKDAY NAME
  // ==========================================================================

  /// Günün adı (Türkçe)
  ///
  /// Örnek: Pazartesi
  String get weekdayName {
    switch (weekday) {
      case DateTime.monday:
        return AppStrings.monday;
      case DateTime.tuesday:
        return AppStrings.tuesday;
      case DateTime.wednesday:
        return AppStrings.wednesday;
      case DateTime.thursday:
        return AppStrings.thursday;
      case DateTime.friday:
        return AppStrings.friday;
      case DateTime.saturday:
        return AppStrings.saturday;
      case DateTime.sunday:
        return AppStrings.sunday;
      default:
        return '';
    }
  }

  /// Günün kısa adı (Türkçe)
  ///
  /// Örnek: Pzt
  String get weekdayShortName {
    switch (weekday) {
      case DateTime.monday:
        return AppStrings.habitFormDayMonday;
      case DateTime.tuesday:
        return AppStrings.habitFormDayTuesday;
      case DateTime.wednesday:
        return AppStrings.habitFormDayWednesday;
      case DateTime.thursday:
        return AppStrings.habitFormDayThursday;
      case DateTime.friday:
        return AppStrings.habitFormDayFriday;
      case DateTime.saturday:
        return AppStrings.habitFormDaySaturday;
      case DateTime.sunday:
        return AppStrings.habitFormDaySunday;
      default:
        return '';
    }
  }

  // ==========================================================================
  // PRIVATE HELPERS
  // ==========================================================================

  /// Ay ismini döndürür (Türkçe)
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return AppStrings.january;
      case 2:
        return AppStrings.february;
      case 3:
        return AppStrings.march;
      case 4:
        return AppStrings.april;
      case 5:
        return AppStrings.may;
      case 6:
        return AppStrings.june;
      case 7:
        return AppStrings.july;
      case 8:
        return AppStrings.august;
      case 9:
        return AppStrings.september;
      case 10:
        return AppStrings.october;
      case 11:
        return AppStrings.november;
      case 12:
        return AppStrings.december;
      default:
        return '';
    }
  }
}
