import 'package:streak_up/features/habits/domain/entities/habit_completion.dart';

/// Alışkanlık tamamlama kaydı veri modeli — SQLite ile uyumlu
///
/// Domain katmanındaki [HabitCompletion] entity'sinin veri katmanı karşılığı.
/// Tarih alanı ISO 8601 date-only formatında saklanır ("2025-02-23").
class HabitCompletionModel {
  /// Tüm alanlarla model oluşturur
  const HabitCompletionModel({
    this.id,
    required this.habitId,
    required this.completedAt,
    this.note,
  });

  /// SQLite Map'ten model oluşturur
  factory HabitCompletionModel.fromMap(Map<String, dynamic> map) {
    return HabitCompletionModel(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int,
      completedAt: map['completed_at'] as String,
      note: map['note'] as String?,
    );
  }

  /// Domain entity'den model oluşturur
  ///
  /// DateTime sadece tarih kısmı alınır (saat bilgisi atılır)
  factory HabitCompletionModel.fromEntity(HabitCompletion entity) {
    return HabitCompletionModel(
      id: entity.id,
      habitId: entity.habitId,
      completedAt: _formatDateOnly(entity.completedAt),
      note: entity.note,
    );
  }

  final int? id;
  final int habitId;
  final String completedAt;
  final String? note;

  /// SQLite Map'e dönüştürür (INSERT için)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'habit_id': habitId,
      'completed_at': completedAt,
      'note': note,
    };
  }

  /// Domain entity'ye dönüştürür
  HabitCompletion toEntity() {
    return HabitCompletion(
      id: id,
      habitId: habitId,
      completedAt: DateTime.parse(completedAt),
      note: note,
    );
  }

  /// DateTime'ı ISO 8601 date-only formatına çevirir
  ///
  /// Örn: 2025-02-23T14:30:00 → "2025-02-23"
  static String _formatDateOnly(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
