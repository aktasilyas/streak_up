import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Kaybedilmek üzere olan streak'i kurtarır
///
/// Rewarded video izlendikten sonra çağrılır.
/// Dünün tarihine tamamlama kaydı ekler, böylece streak kırılmaz.
///
/// İş kuralları:
/// - Dün tamamlanmamış olmalı (zaten tamamlandıysa işlem gereksiz)
/// - Bu UseCase sadece rewarded video başarıyla izlendikten sonra çağrılmalı
class RescueStreak {
  /// [repository] — Veri erişim katmanı
  const RescueStreak(this._repository);

  final HabitRepository _repository;

  /// Dünün tarihine tamamlama kaydı ekleyerek streak'i kurtarır
  ///
  /// [habitId] — Streak'i kurtarılacak alışkanlığın ID'si
  /// Dün zaten tamamlandıysa toggle ile geri alınır,
  /// bu yüzden önce kontrol yapılır.
  Future<void> call(int habitId) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    final alreadyCompleted = await _repository.isCompleted(
      habitId,
      yesterday,
    );

    // Dün zaten tamamlandıysa tekrar toggle yapma
    if (alreadyCompleted) return;

    await _repository.toggleCompletion(habitId, yesterday);
  }
}
