import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_completion.freezed.dart';

/// Alışkanlık tamamlama kaydı entity'si
///
/// Bir alışkanlığın belirli bir günde tamamlandığını gösterir.
/// Her alışkanlık için her gün en fazla bir kayıt olabilir (UNIQUE constraint).
@freezed
class HabitCompletion with _$HabitCompletion {
  /// [id] — Veritabanı tarafından atanır, yeni kayıtlarda null
  /// [habitId] — İlişkili alışkanlığın ID'si
  /// [completedAt] — Tamamlanma tarihi (sadece tarih, saat bilgisi yok)
  /// [note] — İsteğe bağlı not
  const factory HabitCompletion({
    int? id,
    required int habitId,
    required DateTime completedAt,
    String? note,
  }) = _HabitCompletion;
}
