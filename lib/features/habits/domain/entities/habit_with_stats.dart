import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';

part 'habit_with_stats.freezed.dart';

/// Alışkanlık + istatistik verilerini birlikte taşıyan entity
///
/// Listeleme ve detay ekranlarında kullanılır.
/// İstatistikler data katmanında hesaplanır, domain katmanı
/// sadece veri yapısını tanımlar.
@freezed
class HabitWithStats with _$HabitWithStats {
  /// [habit] — Temel alışkanlık bilgileri
  /// [currentStreak] — Mevcut art arda tamamlama serisi
  /// [longestStreak] — En uzun streak rekoru
  /// [completionRate] — Tamamlanma oranı (0.0 - 1.0)
  /// [todayCompleted] — Bugün tamamlandı mı
  /// [completedDates] — Tamamlanan tarihlerin listesi
  const factory HabitWithStats({
    required Habit habit,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0.0) double completionRate,
    @Default(false) bool todayCompleted,
    @Default([]) List<DateTime> completedDates,
  }) = _HabitWithStats;
}
