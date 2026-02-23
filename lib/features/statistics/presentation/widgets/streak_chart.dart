import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/core/extensions/date_extensions.dart';

/// Streak bar chart widget
///
/// Son 7 günün tamamlanan görev sayısını gösterir
class StreakChart extends StatelessWidget {
  /// Constructor
  const StreakChart({
    super.key,
    required this.dailyCompletions,
  });

  /// Günlük tamamlama sayıları (son 7 gün)
  ///
  /// `Map<DateTime, int>` formatında
  final Map<DateTime, int> dailyCompletions;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Son 7 Gün',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            SizedBox(
              height: 200,
              child: _buildBarChart(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Bar chart oluşturur
  Widget _buildBarChart(BuildContext context) {
    final last7Days = _getLast7Days();
    final maxY = _getMaxValue().toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY + 1 : 5,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => context.colorScheme.surfaceContainerHighest,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} görev',
                context.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= last7Days.length) return const Text('');
                final date = last7Days[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    date.weekdayShortName,
                    style: context.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: context.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: context.colorScheme.surfaceContainerHighest,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(context, last7Days),
      ),
    );
  }

  /// Bar grupları oluşturur
  List<BarChartGroupData> _buildBarGroups(
    BuildContext context,
    List<DateTime> days,
  ) {
    final today = DateTime.now().toDateOnly();

    return List.generate(days.length, (index) {
      final date = days[index];
      final count = dailyCompletions[date.toDateOnly()] ?? 0;
      final isToday = date.isSameDay(today);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: isToday
                ? context.colorScheme.primary
                : context.colorScheme.primaryContainer,
            width: 16,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  /// Son 7 günü döndürür
  List<DateTime> _getLast7Days() {
    final today = DateTime.now().toDateOnly();
    return List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  /// Maksimum değer
  int _getMaxValue() {
    if (dailyCompletions.isEmpty) return 5;
    return dailyCompletions.values.reduce((a, b) => a > b ? a : b);
  }
}
