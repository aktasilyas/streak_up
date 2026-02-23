import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_colors.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// Streak badge widget
///
/// Alışkanlık kartlarında streak sayısını gösterir
class StreakBadge extends StatelessWidget {
  /// Constructor
  const StreakBadge({
    super.key,
    required this.streak,
    this.size = AppDimensions.streakBadgeSize,
  });

  /// Streak sayısı
  final int streak;

  /// Badge boyutu
  final double size;

  @override
  Widget build(BuildContext context) {
    // Streak 0 ise gösterme
    if (streak <= 0) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(
        milliseconds: AppDimensions.animationDurationMs,
      ),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getStreakColor(),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _getStreakColor().withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            streak.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Streak sayısına göre renk belirler
  Color _getStreakColor() {
    if (streak >= 30) {
      // 30+ gün: Kırmızı (ateş rengi)
      return const Color(0xFFEF5350);
    } else if (streak >= 7) {
      // 7+ gün: Altın sarısı
      return const Color(0xFFFFCA28);
    } else {
      // 1-6 gün: Normal teal
      return AppColors.seedColor;
    }
  }
}
