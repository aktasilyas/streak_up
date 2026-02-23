import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/core/widgets/app_scaffold.dart';
import 'package:streak_up/core/widgets/empty_state_widget.dart';
import 'package:streak_up/core/widgets/loading_widget.dart';
import 'package:streak_up/core/widgets/responsive_builder.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_list_notifier.dart';
import 'package:streak_up/features/habits/presentation/widgets/habit_card.dart';

/// Alışkanlık listesi ekranı
///
/// Ana ekran — tüm alışkanlıkları listeler
class HabitListScreen extends ConsumerWidget {
  /// Constructor
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
            tooltip: AppStrings.settingsTitle,
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) => _buildHabitList(context, ref, habits),
        loading: () => const LoadingWidget(
          message: AppStrings.loading,
        ),
        error: (error, stack) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(habitListProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to habit form
        },
        child: const Icon(Icons.add),
      ),
      showBannerAd: true,
    );
  }

  /// Alışkanlık listesini oluşturur
  Widget _buildHabitList(
    BuildContext context,
    WidgetRef ref,
    List habits,
  ) {
    if (habits.isEmpty) {
      return ListEmptyState(
        title: AppStrings.habitListEmptyTitle,
        message: AppStrings.habitListEmptyMessage,
        actionLabel: AppStrings.habitListAddButton,
        onActionPressed: () {
          // TODO: Navigate to habit form
        },
      );
    }

    return ResponsiveLayout(
      compact: _buildCompactLayout(context, ref, habits),
      medium: _buildGridLayout(context, ref, habits, crossAxisCount: 2),
      expanded: _buildGridLayout(context, ref, habits, crossAxisCount: 2),
    );
  }

  /// Compact layout - tek kolon liste
  Widget _buildCompactLayout(
    BuildContext context,
    WidgetRef ref,
    List habits,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(habitListProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habitWithStats = habits[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
            child: HabitCard(
              habitWithStats: habitWithStats,
              onTap: () {
                // TODO: Navigate to habit detail
              },
              onToggle: () async {
                await ref.read(habitListProvider.notifier).toggleCompletion(
                      habitWithStats.habit.id!,
                    );
              },
              onDelete: () async {
                await _showDeleteConfirmation(
                  context,
                  ref,
                  habitWithStats.habit.id!,
                );
              },
              onEdit: () {
                // TODO: Navigate to habit form (edit mode)
              },
            ),
          );
        },
      ),
    );
  }

  /// Grid layout - iki veya üç kolon
  Widget _buildGridLayout(
    BuildContext context,
    WidgetRef ref,
    List habits, {
    required int crossAxisCount,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(habitListProvider.notifier).refresh();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppDimensions.paddingM,
          mainAxisSpacing: AppDimensions.paddingM,
          childAspectRatio: 1.2,
        ),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habitWithStats = habits[index];
          return HabitCard(
            habitWithStats: habitWithStats,
            onTap: () {
              // TODO: Navigate to habit detail
            },
            onToggle: () async {
              await ref.read(habitListProvider.notifier).toggleCompletion(
                    habitWithStats.habit.id!,
                  );
            },
            onDelete: () async {
              await _showDeleteConfirmation(
                context,
                ref,
                habitWithStats.habit.id!,
              );
            },
            onEdit: () {
              // TODO: Navigate to habit form (edit mode)
            },
          );
        },
      ),
    );
  }

  /// Silme onay dialog'u gösterir
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    int habitId,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.habitDeleteDialogTitle),
        content: const Text(AppStrings.habitDeleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      await ref.read(habitListProvider.notifier).deleteHabit(habitId);
      if (context.mounted) {
        context.showSuccessSnackBar(AppStrings.habitFormSuccessDelete);
      }
    }
  }
}
