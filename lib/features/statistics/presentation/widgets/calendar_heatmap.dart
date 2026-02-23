import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_colors.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/core/extensions/date_extensions.dart';

/// Calendar heatmap widget
///
/// GitHub contribution graph benzeri görünüm
/// Son 3 ayın takvim grid'i
class CalendarHeatmap extends StatelessWidget {
  /// Constructor
  const CalendarHeatmap({
    super.key,
    required this.completionData,
  });

  /// Tamamlanma verileri
  ///
  /// `Map<DateTime, int>` - Her gün için tamamlanan görev sayısı
  final Map<DateTime, int> completionData;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Son 3 Ay',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            _buildHeatmap(context),
            const SizedBox(height: AppDimensions.paddingM),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  /// Heatmap grid oluşturur
  Widget _buildHeatmap(BuildContext context) {
    final last90Days = _getLast90Days();
    final weeks = _groupByWeeks(last90Days);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weeks.map((week) {
          return Padding(
            padding: const EdgeInsets.only(
              right: AppDimensions.calendarCellSpacing,
            ),
            child: Column(
              children: week.map((date) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.calendarCellSpacing,
                  ),
                  child: _buildDayCell(context, date),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Tek bir gün hücresi
  Widget _buildDayCell(BuildContext context, DateTime date) {
    final count = completionData[date.toDateOnly()] ?? 0;
    final isToday = date.isToday;

    return Container(
      width: AppDimensions.calendarCellSize,
      height: AppDimensions.calendarCellSize,
      decoration: BoxDecoration(
        color: _getCellColor(count),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: isToday
            ? Border.all(
                color: context.colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Tooltip(
        message: '${date.toFormattedString()}\n$count tamamlama',
        child: const SizedBox.expand(),
      ),
    );
  }

  /// Legend (açıklama)
  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Az',
          style: context.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.paddingXs,
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.heatmapColors[index],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
        const SizedBox(width: AppDimensions.paddingS),
        Text(
          'Çok',
          style: context.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Hücre rengi (tamamlanma sayısına göre)
  Color _getCellColor(int count) {
    if (count == 0) return AppColors.heatmapColors[0];
    if (count == 1) return AppColors.heatmapColors[1];
    if (count <= 3) return AppColors.heatmapColors[2];
    if (count <= 5) return AppColors.heatmapColors[3];
    return AppColors.heatmapColors[4];
  }

  /// Son 90 günü döndürür
  List<DateTime> _getLast90Days() {
    final today = DateTime.now().toDateOnly();
    return List.generate(90, (index) {
      return today.subtract(Duration(days: 89 - index));
    });
  }

  /// Günleri haftalara grupla
  List<List<DateTime>> _groupByWeeks(List<DateTime> days) {
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (var i = 0; i < days.length; i++) {
      final day = days[i];

      // İlk gün Pazartesi ile başlamalı
      if (currentWeek.isEmpty && !day.isMonday) {
        // Pazartesi'ye kadar boş hücre ekle
        final daysUntilMonday = (day.weekday - DateTime.monday) % 7;
        for (var j = 0; j < daysUntilMonday; j++) {
          currentWeek.add(day.subtract(Duration(days: daysUntilMonday - j)));
        }
      }

      currentWeek.add(day);

      // Pazar günü geldiğinde hafta tamamlandı
      if (day.isSunday || i == days.length - 1) {
        // Eksik günleri tamamla (7 gün olmalı)
        while (currentWeek.length < 7) {
          currentWeek.add(
            currentWeek.last.add(const Duration(days: 1)),
          );
        }
        weeks.add(currentWeek);
        currentWeek = <DateTime>[];
      }
    }

    return weeks;
  }
}
