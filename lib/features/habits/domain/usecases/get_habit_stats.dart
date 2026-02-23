import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Tek bir alışkanlığın detaylı istatistiklerini getirir
///
/// Detay ekranı ve istatistik sayfasında kullanılır.
/// Streak, tamamlanma oranı ve tarih listesi dahildir.
class GetHabitStats {
  /// [repository] — Veri erişim katmanı
  const GetHabitStats(this._repository);

  final HabitRepository _repository;

  /// Alışkanlığı tüm istatistikleriyle birlikte döner
  ///
  /// [habitId] — İstatistikleri istenen alışkanlığın ID'si
  Future<HabitWithStats> call(int habitId) {
    return _repository.getHabitWithStats(habitId);
  }
}
