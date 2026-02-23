import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Tüm aktif alışkanlıkları istatistikleriyle birlikte getirir
///
/// Ana liste ekranında kullanılır.
/// Repository'den [HabitWithStats] listesi alır — streak, oran vb. dahil.
class GetHabits {
  /// [repository] — Veri erişim katmanı
  const GetHabits(this._repository);

  final HabitRepository _repository;

  /// Tüm aktif alışkanlıkları istatistikleriyle birlikte döner
  ///
  /// Arşivlenmiş alışkanlıklar dahil edilmez.
  /// Sonuç oluşturulma tarihine göre sıralıdır.
  Future<List<HabitWithStats>> call() {
    return _repository.getAllWithStats();
  }
}
