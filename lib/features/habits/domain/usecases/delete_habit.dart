import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Alışkanlığı kalıcı olarak siler
///
/// İlişkili tüm tamamlama kayıtları da silinir (CASCADE).
/// Bu işlem geri alınamaz — UI katmanı onay dialogu göstermelidir.
class DeleteHabit {
  /// [repository] — Veri erişim katmanı
  const DeleteHabit(this._repository);

  final HabitRepository _repository;

  /// Alışkanlığı ve tüm ilişkili verileri siler
  ///
  /// [id] — Silinecek alışkanlığın ID'si
  Future<void> call(int id) {
    return _repository.delete(id);
  }
}
