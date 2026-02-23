import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/core/extensions/date_extensions.dart';
import 'package:streak_up/core/widgets/app_scaffold.dart';
import 'package:streak_up/core/widgets/empty_state_widget.dart';
import 'package:streak_up/core/widgets/loading_widget.dart';
import 'package:streak_up/services/ad_service.dart';
import 'package:streak_up/core/widgets/responsive_builder.dart';
import 'package:streak_up/features/statistics/presentation/providers/stats_provider.dart';
import 'package:streak_up/features/statistics/presentation/widgets/calendar_heatmap.dart';
import 'package:streak_up/features/statistics/presentation/widgets/stats_summary_card.dart';
import 'package:streak_up/features/statistics/presentation/widgets/streak_chart.dart';
import 'package:streak_up/features/statistics/presentation/widgets/weekly_summary_card.dart';

/// İstatistikler ekranı
///
/// Tüm alışkanlıkların veya seçili alışkanlığın istatistiklerini gösterir
class StatsScreen extends ConsumerStatefulWidget {
  /// Constructor
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  /// SharedPreferences goruntuleme sayaci anahtari
  static const String _viewCountKey = 'stats_screen_view_count';

  /// Interstitial gosterilecek goruntuleme frekansi
  static const int _interstitialFrequency = 3;

  @override
  void initState() {
    super.initState();
    _trackViewAndShowInterstitial();
  }

  /// Goruntuleme sayacini artir ve gerekirse interstitial goster
  Future<void> _trackViewAndShowInterstitial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final viewCount = (prefs.getInt(_viewCountKey) ?? 0) + 1;
      await prefs.setInt(_viewCountKey, viewCount);

      // Her 3. goruntulemede interstitial goster
      if (viewCount % _interstitialFrequency == 0) {
        await AdService.instance.showInterstitial();
      }
    } on Exception catch (e) {
      debugPrint('StatsScreen: Interstitial hata -> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(statsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(statsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: statsState.isLoading
          ? const LoadingWidget(message: AppStrings.loading)
          : statsState.errorMessage != null
              ? ErrorStateWidget(
                  message: statsState.errorMessage!,
                  onRetry: () => ref.read(statsProvider.notifier).refresh(),
                )
              : statsState.habits.isEmpty
                  ? const ListEmptyState(
                      title: AppStrings.statsEmptyTitle,
                      message: AppStrings.statsEmptyMessage,
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(statsProvider.notifier).refresh(),
                      child: ResponsiveLayout(
                        compact: _buildCompactLayout(context, statsState),
                        medium: _buildExpandedLayout(context, statsState),
                        expanded: _buildExpandedLayout(context, statsState),
                      ),
                    ),
    );
  }

  /// Compact layout (telefon portrait)
  Widget _buildCompactLayout(BuildContext context, StatsState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCards(context, state),
          const SizedBox(height: AppDimensions.paddingL),
          _buildFilters(context, state),
          const SizedBox(height: AppDimensions.paddingL),
          if (state.selectedHabit != null) ...[
            _buildSelectedHabitStats(context, state),
          ] else ...[
            _buildOverallStats(context, state),
          ],
        ],
      ),
    );
  }

  /// Expanded layout (tablet/desktop)
  Widget _buildExpandedLayout(BuildContext context, StatsState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCards(context, state),
          const SizedBox(height: AppDimensions.paddingL),
          _buildFilters(context, state),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: state.selectedHabit != null
                    ? _buildSelectedHabitStats(context, state)
                    : _buildOverallStats(context, state),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Özet kartları
  Widget _buildSummaryCards(BuildContext context, StatsState state) {
    return ResponsiveLayout(
      compact: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatsSummaryCard(
                  icon: '🔥',
                  value: '${state.totalCurrentStreak}',
                  label: AppStrings.statsCurrentStreak,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: StatsSummaryCard(
                  icon: '✅',
                  value: '${state.completedToday}',
                  label: AppStrings.statsCompletedToday,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            children: [
              Expanded(
                child: StatsSummaryCard(
                  icon: '📊',
                  value: '${(state.averageCompletionRate * 100).toInt()}%',
                  label: AppStrings.statsWeeklyCompletionRate,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: StatsSummaryCard(
                  icon: '💪',
                  value: '${state.totalActiveHabits}',
                  label: AppStrings.statsActiveHabits,
                ),
              ),
            ],
          ),
        ],
      ),
      medium: Row(
        children: [
          Expanded(
            child: StatsSummaryCard(
              icon: '🔥',
              value: '${state.totalCurrentStreak}',
              label: AppStrings.statsCurrentStreak,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: StatsSummaryCard(
              icon: '✅',
              value: '${state.completedToday}',
              label: AppStrings.statsCompletedToday,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: StatsSummaryCard(
              icon: '📊',
              value: '${(state.averageCompletionRate * 100).toInt()}%',
              label: AppStrings.statsWeeklyCompletionRate,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: StatsSummaryCard(
              icon: '💪',
              value: '${state.totalActiveHabits}',
              label: AppStrings.statsActiveHabits,
            ),
          ),
        ],
      ),
    );
  }

  /// Filtreler (alışkanlık seçici + tarih aralığı)
  Widget _buildFilters(BuildContext context, StatsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHabitSelector(context, state),
        const SizedBox(height: AppDimensions.paddingM),
        _buildDateRangeChips(context, state),
      ],
    );
  }

  /// Alışkanlık seçici dropdown
  Widget _buildHabitSelector(BuildContext context, StatsState state) {
    return DropdownButtonFormField<int?>(
      initialValue: state.selectedHabitId,
      decoration: InputDecoration(
        labelText: AppStrings.statsSelectHabit,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      items: [
        DropdownMenuItem<int?>(
          value: null,
          child: Text(AppStrings.statsAllHabits),
        ),
        ...state.habits.map((habitWithStats) {
          return DropdownMenuItem<int?>(
            value: habitWithStats.habit.id,
            child: Row(
              children: [
                Text(habitWithStats.habit.icon),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    habitWithStats.habit.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      onChanged: (value) {
        ref.read(statsProvider.notifier).selectHabit(value);
      },
    );
  }

  /// Tarih aralığı chip'leri
  Widget _buildDateRangeChips(BuildContext context, StatsState state) {
    return Wrap(
      spacing: AppDimensions.paddingS,
      children: [
        FilterChip(
          label: const Text(AppStrings.statsPeriodWeek),
          selected: state.dateRange == DateRange.week,
          onSelected: (_) {
            ref
                .read(statsProvider.notifier)
                .selectDateRange(DateRange.week);
          },
        ),
        FilterChip(
          label: const Text(AppStrings.statsPeriodMonth),
          selected: state.dateRange == DateRange.month,
          onSelected: (_) {
            ref
                .read(statsProvider.notifier)
                .selectDateRange(DateRange.month);
          },
        ),
        FilterChip(
          label: const Text(AppStrings.statsPeriodAll),
          selected: state.dateRange == DateRange.all,
          onSelected: (_) {
            ref.read(statsProvider.notifier).selectDateRange(DateRange.all);
          },
        ),
      ],
    );
  }

  /// Seçili alışkanlık istatistikleri
  Widget _buildSelectedHabitStats(BuildContext context, StatsState state) {
    final habit = state.selectedHabit!;

    return Column(
      children: [
        WeeklySummaryCard(
          completedTasks: habit.completedDates
              .where((d) => d.isAfter(DateTime.now().startOfWeek))
              .length,
          totalTasks: 7,
          longestStreak: habit.longestStreak,
        ),
        const SizedBox(height: AppDimensions.paddingL),
        _buildStreakChart(state),
        const SizedBox(height: AppDimensions.paddingL),
        _buildCalendarHeatmap(state),
      ],
    );
  }

  /// Genel istatistikler (tüm alışkanlıklar)
  Widget _buildOverallStats(BuildContext context, StatsState state) {
    return Column(
      children: [
        WeeklySummaryCard(
          completedTasks: _getWeeklyCompletedTasks(state),
          totalTasks: _getWeeklyTotalTasks(state),
          longestStreak: state.longestStreak,
        ),
        const SizedBox(height: AppDimensions.paddingL),
        _buildStreakChart(state),
        const SizedBox(height: AppDimensions.paddingL),
        _buildCalendarHeatmap(state),
      ],
    );
  }

  /// Streak chart
  Widget _buildStreakChart(StatsState state) {
    final dailyCompletions = _getDailyCompletions(state);
    return StreakChart(dailyCompletions: dailyCompletions);
  }

  /// Calendar heatmap
  Widget _buildCalendarHeatmap(StatsState state) {
    final completionData = _getCompletionData(state);
    return CalendarHeatmap(completionData: completionData);
  }

  /// Günlük tamamlanma sayıları (son 7 gün)
  Map<DateTime, int> _getDailyCompletions(StatsState state) {
    final result = <DateTime, int>{};
    final today = DateTime.now().toDateOnly();

    for (var i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      int count = 0;

      if (state.selectedHabit != null) {
        // Seçili alışkanlık için
        if (state.selectedHabit!.completedDates
            .any((d) => d.toDateOnly().isSameDay(date))) {
          count = 1;
        }
      } else {
        // Tüm alışkanlıklar için
        for (final habit in state.habits) {
          if (habit.completedDates
              .any((d) => d.toDateOnly().isSameDay(date))) {
            count++;
          }
        }
      }

      result[date] = count;
    }

    return result;
  }

  /// Tamamlanma verileri (son 90 gün)
  Map<DateTime, int> _getCompletionData(StatsState state) {
    final result = <DateTime, int>{};
    final today = DateTime.now().toDateOnly();

    for (var i = 0; i < 90; i++) {
      final date = today.subtract(Duration(days: 89 - i));
      int count = 0;

      if (state.selectedHabit != null) {
        // Seçili alışkanlık için
        if (state.selectedHabit!.completedDates
            .any((d) => d.toDateOnly().isSameDay(date))) {
          count = 1;
        }
      } else {
        // Tüm alışkanlıklar için
        for (final habit in state.habits) {
          if (habit.completedDates
              .any((d) => d.toDateOnly().isSameDay(date))) {
            count++;
          }
        }
      }

      result[date] = count;
    }

    return result;
  }

  /// Haftalık tamamlanan görevler
  int _getWeeklyCompletedTasks(StatsState state) {
    final startOfWeek = DateTime.now().startOfWeek;
    int count = 0;

    for (final habit in state.habits) {
      count += habit.completedDates
          .where((d) => d.isAfter(startOfWeek))
          .length;
    }

    return count;
  }

  /// Haftalık toplam görevler
  int _getWeeklyTotalTasks(StatsState state) {
    return state.habits.length * 7; // Basit hesaplama
  }
}
