import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_providers.dart';

/// Tarih aralığı enum
enum DateRange {
  /// Bu hafta
  week,

  /// Bu ay
  month,

  /// Tüm zamanlar
  all,
}

/// İstatistik state
class StatsState {
  /// Constructor
  const StatsState({
    this.selectedHabitId,
    this.dateRange = DateRange.week,
    this.habits = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Seçili alışkanlık ID (null ise tümü)
  final int? selectedHabitId;

  /// Tarih aralığı filtresi
  final DateRange dateRange;

  /// Tüm alışkanlıklar
  final List<HabitWithStats> habits;

  /// Yükleniyor mu?
  final bool isLoading;

  /// Hata mesajı
  final String? errorMessage;

  /// Seçili alışkanlık
  HabitWithStats? get selectedHabit {
    if (selectedHabitId == null) return null;
    try {
      return habits.firstWhere((h) => h.habit.id == selectedHabitId);
    } catch (_) {
      return null;
    }
  }

  /// Toplam aktif alışkanlık sayısı
  int get totalActiveHabits => habits.length;

  /// Bugün tamamlanan alışkanlık sayısı
  int get completedToday => habits.where((h) => h.todayCompleted).length;

  /// Toplam mevcut streak (tüm alışkanlıklar)
  int get totalCurrentStreak {
    return habits.fold(0, (sum, h) => sum + h.currentStreak);
  }

  /// Ortalama tamamlanma oranı
  double get averageCompletionRate {
    if (habits.isEmpty) return 0.0;
    final sum = habits.fold(0.0, (sum, h) => sum + h.completionRate);
    return sum / habits.length;
  }

  /// En uzun streak
  int get longestStreak {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
  }

  /// CopyWith
  StatsState copyWith({
    int? Function()? selectedHabitId,
    DateRange? dateRange,
    List<HabitWithStats>? habits,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return StatsState(
      selectedHabitId: selectedHabitId != null
          ? selectedHabitId()
          : this.selectedHabitId,
      dateRange: dateRange ?? this.dateRange,
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// İstatistik notifier
class StatsNotifier extends StateNotifier<StatsState> {
  /// Constructor
  StatsNotifier(this.ref) : super(const StatsState()) {
    loadHabits();
  }

  /// Ref
  final Ref ref;

  /// Alışkanlıkları yükle
  Future<void> loadHabits() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final getHabits = ref.read(getHabitsProvider);
      final habits = await getHabits();

      state = state.copyWith(
        habits: habits,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Veriler yüklenemedi: $e',
      );
    }
  }

  /// Alışkanlık seç
  void selectHabit(int? habitId) {
    state = state.copyWith(selectedHabitId: () => habitId);
  }

  /// Tarih aralığı seç
  void selectDateRange(DateRange range) {
    state = state.copyWith(dateRange: range);
  }

  /// Yenile
  Future<void> refresh() => loadHabits();
}

/// Stats provider
final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  return StatsNotifier(ref);
});
