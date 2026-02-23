import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// Yeni alışkanlık oluşturur — validasyon dahil
///
/// İş kuralları:
/// - İsim boş olamaz ve 1-100 karakter arası olmalı
/// - Haftalık/özel sıklıkta targetDays zorunlu ve 1-7 arası
/// - Hatırlatma saati "HH:mm" formatında olmalı
class CreateHabit {
  /// [repository] — Veri erişim katmanı
  const CreateHabit(this._repository);

  final HabitRepository _repository;

  /// Validasyon kurallarını uygular ve alışkanlığı oluşturur
  ///
  /// Validasyon hatası durumunda [ArgumentError] fırlatır.
  /// Başarılı olursa veritabanı ID'si atanmış [Habit] döner.
  Future<Habit> call(Habit habit) async {
    _validateName(habit.name);
    _validateTargetDays(habit.frequency, habit.targetDays);
    _validateReminderTime(habit.reminderTime);

    final now = DateTime.now();
    final habitToCreate = habit.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    return _repository.create(habitToCreate);
  }

  /// İsim validasyonu
  void _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Alışkanlık adı boş olamaz');
    }
    if (trimmed.length > 100) {
      throw ArgumentError('Alışkanlık adı 100 karakteri geçemez');
    }
  }

  /// Hedef gün validasyonu
  ///
  /// Haftalık veya özel sıklıkta en az bir hedef gün seçilmeli.
  /// Gün değerleri 1 (Pazartesi) - 7 (Pazar) arasında olmalı.
  void _validateTargetDays(
    HabitFrequency frequency,
    List<int>? targetDays,
  ) {
    if (frequency == HabitFrequency.daily) return;

    if (targetDays == null || targetDays.isEmpty) {
      throw ArgumentError(
        'Haftalık veya özel sıklıkta en az bir gün seçilmeli',
      );
    }

    final invalidDays = targetDays.where((d) => d < 1 || d > 7);
    if (invalidDays.isNotEmpty) {
      throw ArgumentError(
        'Geçersiz gün değerleri: $invalidDays (1-7 arası olmalı)',
      );
    }
  }

  /// Hatırlatma saati format validasyonu
  ///
  /// "HH:mm" formatında olmalı (örn: "08:30", "21:00")
  void _validateReminderTime(String? reminderTime) {
    if (reminderTime == null) return;

    final parts = reminderTime.split(':');
    if (parts.length != 2) {
      throw ArgumentError(
        'Hatırlatma saati "HH:mm" formatında olmalı',
      );
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      throw ArgumentError(
        'Hatırlatma saati geçerli sayılar içermeli',
      );
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw ArgumentError(
        'Geçersiz saat: $reminderTime (00:00 - 23:59 arası)',
      );
    }
  }
}
