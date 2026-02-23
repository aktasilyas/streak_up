import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Alışkanlığın belirli bir gündeki tamamlama durumunu değiştirir
///
/// Tamamlanmadıysa tamamlar, tamamlandıysa geri alır (toggle).
/// Ana ekranda check butonuna basıldığında çağrılır.
class ToggleHabitCompletion {
  /// [repository] — Veri erişim katmanı
  const ToggleHabitCompletion(this._repository);

  final HabitRepository _repository;

  /// Tamamlama durumunu tersine çevirir
  ///
  /// [habitId] — Alışkanlık ID'si
  /// [date] — Tamamlama tarihi (varsayılan: bugün)
  Future<void> call(int habitId, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    return _repository.toggleCompletion(habitId, targetDate);
  }
}
