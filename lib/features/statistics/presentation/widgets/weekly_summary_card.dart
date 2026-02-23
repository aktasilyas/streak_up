import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';

/// Haftalık özet kartı widget
///
/// Bu haftanın özet bilgilerini gösterir
class WeeklySummaryCard extends StatelessWidget {
  /// Constructor
  const WeeklySummaryCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.longestStreak,
  });

  /// Tamamlanan görev sayısı
  final int completedTasks;

  /// Toplam görev sayısı
  final int totalTasks;

  /// En uzun streak
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.statsWeeklySummaryTitle,
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Row(
              children: [
                Expanded(
                  child: _buildCircularProgress(context, completionRate),
                ),
                const SizedBox(width: AppDimensions.paddingL),
                Expanded(
                  flex: 2,
                  child: _buildStats(context),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildMotivationMessage(context, completionRate),
          ],
        ),
      ),
    );
  }

  /// Circular progress göstergesi
  Widget _buildCircularProgress(BuildContext context, double rate) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: rate,
              strokeWidth: 8,
              backgroundColor:
                  context.colorScheme.surfaceContainerHighest,
              color: _getProgressColor(context, rate),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(rate * 100).toInt()}%',
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppStrings.statsWeeklyCompletionRate,
                style: context.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// İstatistik bilgileri
  Widget _buildStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow(
          context,
          icon: '✅',
          label: AppStrings.statsCompletedTasks,
          value: '$completedTasks / $totalTasks',
        ),
        const SizedBox(height: AppDimensions.paddingM),
        _buildStatRow(
          context,
          icon: '🔥',
          label: AppStrings.statsActiveStreakLabel,
          value: '$longestStreak gün',
        ),
      ],
    );
  }

  /// Tek bir istatistik satırı
  Widget _buildStatRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: context.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Motivasyon mesajı
  Widget _buildMotivationMessage(BuildContext context, double rate) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: _getProgressColor(context, rate).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          Text(
            _getMotivationEmoji(rate),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              _getMotivationMessage(rate),
              style: context.bodyMedium?.copyWith(
                color: _getProgressColor(context, rate),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tamamlanma oranına göre renk
  Color _getProgressColor(BuildContext context, double rate) {
    if (rate >= 0.8) {
      return const Color(0xFF4CAF50); // Yeşil
    } else if (rate >= 0.5) {
      return const Color(0xFFFF9800); // Turuncu
    } else {
      return context.colorScheme.error; // Kırmızı
    }
  }

  /// Motivasyon emoji
  String _getMotivationEmoji(double rate) {
    if (rate >= 0.8) return '🎉';
    if (rate >= 0.5) return '💪';
    return '🔥';
  }

  /// Motivasyon mesajı
  String _getMotivationMessage(double rate) {
    if (rate >= 0.8) {
      return AppStrings.statsMotivationExcellent;
    } else if (rate >= 0.5) {
      return AppStrings.statsMotivationGood;
    } else if (rate >= 0.2) {
      return AppStrings.statsMotivationNeedsWork;
    } else {
      return AppStrings.statsMotivationKeepGoing;
    }
  }
}
