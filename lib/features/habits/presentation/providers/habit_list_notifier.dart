import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_providers.dart';
import 'package:streak_up/services/notification_service.dart';

/// Alışkanlık listesi state provider'ı
///
/// Ana liste ekranında kullanılır. [AsyncNotifierProvider] ile
/// yükleme, hata ve veri durumlarını yönetir.
final habitListProvider =
    AsyncNotifierProvider<HabitListNotifier, List<HabitWithStats>>(
  HabitListNotifier.new,
);

/// Alışkanlık listesi state yöneticisi
///
/// Tüm liste işlemlerini (yükleme, toggle, silme, streak kurtarma)
/// UseCase'ler aracılığıyla gerçekleştirir.
/// İş mantığı burada YOKTUR — sadece UseCase çağrısı ve state güncellemesi.
class HabitListNotifier extends AsyncNotifier<List<HabitWithStats>> {
  @override
  Future<List<HabitWithStats>> build() => loadHabits();

  /// Tüm aktif alışkanlıkları istatistikleriyle birlikte yükler
  Future<List<HabitWithStats>> loadHabits() async {
    final getHabits = ref.read(getHabitsProvider);
    return getHabits();
  }

  /// Listeyi yeniden yükler
  ///
  /// CRUD işlemlerinden sonra çağrılır — güncel veriyi çeker
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadHabits);
  }

  /// Tamamlama durumunu tersine çevirir ve listeyi günceller
  ///
  /// [habitId] — Alışkanlık ID'si
  /// [date] — Tamamlama tarihi (null ise bugün)
  Future<void> toggleCompletion(int habitId, {DateTime? date}) async {
    try {
      final toggleUseCase = ref.read(toggleCompletionProvider);
      await toggleUseCase(habitId, date: date);
      await refresh();
    } on Exception catch (e, st) {
      debugPrint('HabitListNotifier: Toggle hatası → $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// Alışkanlığı kalıcı olarak siler ve listeyi günceller
  ///
  /// [id] — Silinecek alışkanlığın ID'si
  Future<void> deleteHabit(int id) async {
    try {
      final deleteUseCase = ref.read(deleteHabitProvider);
      await deleteUseCase(id);

      // Silinen alışkanlığın bildirimini iptal et
      await NotificationService.instance.cancel(id);

      await refresh();
    } on Exception catch (e, st) {
      debugPrint('HabitListNotifier: Silme hatası → $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// Streak'i kurtarır (dünü tamamla) ve listeyi günceller
  ///
  /// Rewarded video başarıyla izlendikten sonra çağrılmalı.
  /// [habitId] — Streak'i kurtarılacak alışkanlığın ID'si
  Future<void> rescueStreak(int habitId) async {
    try {
      final rescueUseCase = ref.read(rescueStreakProvider);
      await rescueUseCase(habitId);
      await refresh();
    } on Exception catch (e, st) {
      debugPrint('HabitListNotifier: Streak kurtarma hatası → $e');
      state = AsyncValue.error(e, st);
    }
  }
}
