import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_providers.dart';

/// Form state provider'ı
///
/// Alışkanlık oluşturma ve düzenleme ekranında kullanılır.
/// autoDispose ile ekrandan çıkınca state temizlenir.
final habitFormProvider =
    NotifierProvider.autoDispose<HabitFormNotifier, HabitFormState>(
  HabitFormNotifier.new,
);

/// Alışkanlık form state'i — immutable
///
/// Form alanlarının güncel değerlerini ve validasyon durumunu taşır.
@immutable
class HabitFormState {
  const HabitFormState({
    this.name = '',
    this.description = '',
    this.icon = '✅',
    this.color = 0xFF4CAF50,
    this.frequency = HabitFrequency.daily,
    this.targetDays = const [],
    this.reminderTime,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String name;
  final String description;
  final String icon;
  final int color;
  final HabitFrequency frequency;
  final List<int> targetDays;
  final String? reminderTime;
  final bool isSubmitting;
  final String? errorMessage;

  /// Form geçerli mi — en az 1 karakter isim zorunlu
  bool get isValid => name.trim().isNotEmpty;

  /// Hedef gün validasyonu — haftalık/özel'de en az 1 gün seçilmeli
  bool get isTargetDaysValid {
    if (frequency == HabitFrequency.daily) return true;
    return targetDays.isNotEmpty;
  }

  /// Formun gönderilebilir olup olmadığı
  bool get canSubmit => isValid && isTargetDaysValid && !isSubmitting;

  /// copyWith — immutable state güncellemesi
  HabitFormState copyWith({
    String? name,
    String? description,
    String? icon,
    int? color,
    HabitFrequency? frequency,
    List<int>? targetDays,
    String? Function()? reminderTime,
    bool? isSubmitting,
    String? Function()? errorMessage,
  }) {
    return HabitFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      targetDays: targetDays ?? this.targetDays,
      reminderTime:
          reminderTime != null ? reminderTime() : this.reminderTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// Alışkanlık form state yöneticisi
///
/// Form alanlarını günceller, validasyon yapar ve
/// UseCase'ler aracılığıyla CRUD işlemlerini tetikler.
class HabitFormNotifier extends AutoDisposeNotifier<HabitFormState> {
  @override
  HabitFormState build() => const HabitFormState();

  // ===========================================================================
  // ALAN GÜNCELLEME
  // ===========================================================================

  /// İsim alanını günceller
  void setName(String value) {
    state = state.copyWith(
      name: value,
      errorMessage: () => null,
    );
  }

  /// Açıklama alanını günceller
  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  /// İkon alanını günceller
  void setIcon(String value) {
    state = state.copyWith(icon: value);
  }

  /// Renk alanını günceller
  void setColor(int value) {
    state = state.copyWith(color: value);
  }

  /// Sıklık alanını günceller
  ///
  /// Daily'ye geçilirse targetDays temizlenir
  void setFrequency(HabitFrequency value) {
    state = state.copyWith(
      frequency: value,
      targetDays: value == HabitFrequency.daily ? [] : state.targetDays,
    );
  }

  /// Hedef gün ekler/çıkarır (toggle)
  ///
  /// [day] — 1 (Pazartesi) - 7 (Pazar)
  void toggleTargetDay(int day) {
    final current = List<int>.from(state.targetDays);
    if (current.contains(day)) {
      current.remove(day);
    } else {
      current.add(day);
    }
    current.sort();
    state = state.copyWith(targetDays: current);
  }

  /// Hatırlatma saatini ayarlar
  ///
  /// [time] — "HH:mm" formatında, null ile iptal edilir
  void setReminderTime(String? time) {
    state = state.copyWith(reminderTime: () => time);
  }

  // ===========================================================================
  // MEVCUT ALIŞKANLIĞI YÜKLEME (Düzenleme modu)
  // ===========================================================================

  /// Mevcut alışkanlık verilerini form'a yükler
  void loadFromHabit(Habit habit) {
    state = HabitFormState(
      name: habit.name,
      description: habit.description ?? '',
      icon: habit.icon,
      color: habit.color,
      frequency: habit.frequency,
      targetDays: habit.targetDays ?? [],
      reminderTime: habit.reminderTime,
    );
  }

  // ===========================================================================
  // FORM GÖNDERME
  // ===========================================================================

  /// Yeni alışkanlık oluşturur
  ///
  /// Başarılı olursa true, hata olursa false döner.
  Future<bool> createHabit() async {
    if (!state.canSubmit) return false;

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: () => null,
    );

    try {
      final createUseCase = ref.read(createHabitProvider);
      final now = DateTime.now();

      await createUseCase(Habit(
        name: state.name.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        icon: state.icon,
        color: state.color,
        frequency: state.frequency,
        targetDays: state.frequency == HabitFrequency.daily
            ? null
            : state.targetDays,
        reminderTime: state.reminderTime,
        createdAt: now,
        updatedAt: now,
      ));

      return true;
    } on ArgumentError catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: () => e.message as String,
      );
      return false;
    } on Exception catch (e) {
      debugPrint('HabitFormNotifier: Oluşturma hatası → $e');
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: () => 'Bir hata oluştu',
      );
      return false;
    }
  }

  /// Mevcut alışkanlığı günceller
  ///
  /// [id] — Güncellenecek alışkanlığın ID'si
  /// Başarılı olursa true, hata olursa false döner.
  Future<bool> updateHabit(int id) async {
    if (!state.canSubmit) return false;

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: () => null,
    );

    try {
      final updateUseCase = ref.read(updateHabitProvider);
      final now = DateTime.now();

      await updateUseCase(Habit(
        id: id,
        name: state.name.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        icon: state.icon,
        color: state.color,
        frequency: state.frequency,
        targetDays: state.frequency == HabitFrequency.daily
            ? null
            : state.targetDays,
        reminderTime: state.reminderTime,
        createdAt: now,
        updatedAt: now,
      ));

      return true;
    } on ArgumentError catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: () => e.message as String,
      );
      return false;
    } on Exception catch (e) {
      debugPrint('HabitFormNotifier: Güncelleme hatası → $e');
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: () => 'Bir hata oluştu',
      );
      return false;
    }
  }
}
