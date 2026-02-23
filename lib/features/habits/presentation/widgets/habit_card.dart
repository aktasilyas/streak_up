import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/presentation/widgets/habit_check_button.dart';
import 'package:streak_up/features/habits/presentation/widgets/streak_badge.dart';

/// Alışkanlık kartı widget
///
/// Liste ve grid görünümlerinde kullanılır
class HabitCard extends StatelessWidget {
  /// Constructor
  const HabitCard({
    super.key,
    required this.habitWithStats,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  /// Alışkanlık ve istatistik verisi
  final HabitWithStats habitWithStats;

  /// Kart tıklama callback
  final VoidCallback onTap;

  /// Tamamlanma durumu değiştirme callback
  final VoidCallback onToggle;

  /// Silme callback
  final VoidCallback onDelete;

  /// Düzenleme callback
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('habit_${habitWithStats.habit.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(context),
      confirmDismiss: (_) async {
        HapticFeedback.mediumImpact();
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (_) => onDelete(),
      child: Card.filled(
        child: InkWell(
          onTap: onTap,
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onEdit();
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                _buildIconSection(context),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: _buildContentSection(context),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                _buildCheckSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// İkon bölümü (sol)
  Widget _buildIconSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppDimensions.habitIconContainerSize,
          height: AppDimensions.habitIconContainerSize,
          decoration: BoxDecoration(
            color: Color(habitWithStats.habit.color).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              habitWithStats.habit.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        if (habitWithStats.currentStreak > 0) ...[
          const SizedBox(height: AppDimensions.paddingS),
          StreakBadge(streak: habitWithStats.currentStreak),
        ],
      ],
    );
  }

  /// İçerik bölümü (orta)
  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          habitWithStats.habit.name,
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (habitWithStats.habit.description != null) ...[
          const SizedBox(height: AppDimensions.paddingXs),
          Text(
            habitWithStats.habit.description!,
            style: context.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (habitWithStats.currentStreak > 0) ...[
          const SizedBox(height: AppDimensions.paddingS),
          Row(
            children: [
              Text(
                '🔥 ${habitWithStats.currentStreak}',
                style: context.labelMedium?.copyWith(
                  color: _getStreakColor(habitWithStats.currentStreak),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXs),
              Text(
                habitWithStats.currentStreak == 1 ? 'gün' : 'gün',
                style: context.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Checkbox bölümü (sağ)
  Widget _buildCheckSection(BuildContext context) {
    return HabitCheckButton(
      isCompleted: habitWithStats.todayCompleted,
      color: Color(habitWithStats.habit.color),
      onToggle: onToggle,
    );
  }

  /// Silme arka planı
  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: context.colorScheme.error,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Icon(
        Icons.delete_outline,
        color: context.colorScheme.onError,
        size: AppDimensions.iconL,
      ),
    );
  }

  /// Silme onay dialog
  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Alışkanlığı Sil'),
            content: const Text(
              'Bu alışkanlığı silmek istediğinden emin misin?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                ),
                child: const Text('Sil'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Streak rengini belirler
  Color _getStreakColor(int streak) {
    if (streak >= 30) return const Color(0xFFEF5350); // Kırmızı
    if (streak >= 7) return const Color(0xFFFFCA28); // Altın
    return const Color(0xFF26A69A); // Normal
  }
}
