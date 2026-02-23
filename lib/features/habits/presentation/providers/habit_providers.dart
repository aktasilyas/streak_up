import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/habits/domain/usecases/create_habit.dart';
import 'package:streak_up/features/habits/domain/usecases/delete_habit.dart';
import 'package:streak_up/features/habits/domain/usecases/get_habit_stats.dart';
import 'package:streak_up/features/habits/domain/usecases/get_habits.dart';
import 'package:streak_up/features/habits/domain/usecases/rescue_streak.dart';
import 'package:streak_up/features/habits/domain/usecases/toggle_habit_completion.dart';
import 'package:streak_up/features/habits/domain/usecases/update_habit.dart';
import 'package:streak_up/services/database_service.dart';

// =============================================================================
// DATA KATMANI PROVIDER'LARI
// =============================================================================

/// Yerel veri kaynağı provider'ı
///
/// DatabaseService singleton'ını kullanarak SQLite işlemleri yapar
final habitLocalDatasourceProvider = Provider<HabitLocalDatasource>((ref) {
  return HabitLocalDatasource(DatabaseService.instance);
});

/// Repository provider'ı — Domain katmanı bu arayüze bağımlı
///
/// Dependency Inversion: Presentation → Domain (abstract) ← Data (impl)
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(ref.watch(habitLocalDatasourceProvider));
});

// =============================================================================
// USECASE PROVIDER'LARI
// =============================================================================

/// Tüm aktif alışkanlıkları istatistikleriyle birlikte getirir
final getHabitsProvider = Provider<GetHabits>((ref) {
  return GetHabits(ref.watch(habitRepositoryProvider));
});

/// Yeni alışkanlık oluşturur (validasyon dahil)
final createHabitProvider = Provider<CreateHabit>((ref) {
  return CreateHabit(ref.watch(habitRepositoryProvider));
});

/// Mevcut alışkanlığı günceller (validasyon dahil)
final updateHabitProvider = Provider<UpdateHabit>((ref) {
  return UpdateHabit(ref.watch(habitRepositoryProvider));
});

/// Alışkanlığı kalıcı olarak siler
final deleteHabitProvider = Provider<DeleteHabit>((ref) {
  return DeleteHabit(ref.watch(habitRepositoryProvider));
});

/// Tamamlama durumunu tersine çevirir (toggle)
final toggleCompletionProvider = Provider<ToggleHabitCompletion>((ref) {
  return ToggleHabitCompletion(ref.watch(habitRepositoryProvider));
});

/// Tek alışkanlığın detaylı istatistiklerini getirir
final getHabitStatsProvider = Provider<GetHabitStats>((ref) {
  return GetHabitStats(ref.watch(habitRepositoryProvider));
});

/// Kaybedilmek üzere olan streak'i kurtarır (rewarded video sonrası)
final rescueStreakProvider = Provider<RescueStreak>((ref) {
  return RescueStreak(ref.watch(habitRepositoryProvider));
});
