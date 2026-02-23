/// Alışkanlık tekrar sıklığı
///
/// Streak hesaplama stratejisi bu enum'a göre belirlenir.
/// - [daily]: Her gün yapılması gereken alışkanlık
/// - [weekly]: Haftanın belirli günlerinde yapılması gereken alışkanlık
/// - [custom]: Özel gün seçimi ile yapılması gereken alışkanlık
enum HabitFrequency {
  /// Her gün yapılması gereken alışkanlık
  daily,

  /// Haftanın belirli günlerinde yapılması gereken alışkanlık
  weekly,

  /// Özel gün seçimi ile yapılması gereken alışkanlık
  custom;

  /// String değerden enum'a dönüştürür
  ///
  /// Geçersiz değer gelirse [daily] döner (güvenli varsayılan)
  static HabitFrequency fromString(String value) {
    return HabitFrequency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => HabitFrequency.daily,
    );
  }
}
