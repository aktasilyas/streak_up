import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streak_up/features/habits/domain/enums/habit_frequency.dart';

part 'habit.freezed.dart';

/// Alışkanlık entity'si — Domain katmanının temel veri yapısı
///
/// Immutable sınıf — tüm değişiklikler [copyWith] ile yapılır.
/// Veritabanı veya UI detaylarından bağımsızdır.
@freezed
class Habit with _$Habit {
  /// Yeni bir [Habit] oluşturur
  ///
  /// [id] — Veritabanı tarafından atanır, yeni kayıtlarda null
  /// [name] — Alışkanlık adı (zorunlu)
  /// [description] — Açıklama (isteğe bağlı)
  /// [icon] — Emoji ikonu (varsayılan: ✅)
  /// [color] — ARGB renk değeri (varsayılan: yeşil)
  /// [frequency] — Tekrar sıklığı (varsayılan: günlük)
  /// [targetDays] — Hedef günler, 1=Pazartesi 7=Pazar (haftalık/özel için)
  /// [reminderTime] — Hatırlatma saati "HH:mm" formatında
  /// [createdAt] — Oluşturulma tarihi
  /// [updatedAt] — Son güncelleme tarihi
  /// [isArchived] — Arşivlenmiş mi
  const factory Habit({
    int? id,
    required String name,
    String? description,
    @Default('✅') String icon,
    @Default(0xFF4CAF50) int color,
    @Default(HabitFrequency.daily) HabitFrequency frequency,
    List<int>? targetDays,
    String? reminderTime,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isArchived,
  }) = _Habit;
}
