import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';

/// İstatistik özet kartı widget
///
/// Tek bir istatistik gösterir (icon + değer + label)
class StatsSummaryCard extends StatelessWidget {
  /// Constructor
  const StatsSummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
    this.onTap,
  });

  /// İkon (emoji veya IconData)
  final dynamic icon;

  /// Değer
  final String value;

  /// Etiket
  final String label;

  /// Renk (null ise primary)
  final Color? color;

  /// Tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? context.colorScheme.primary;

    return Card.filled(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(context, cardColor),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                value,
                style: context.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXs),
              Text(
                label,
                style: context.labelMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// İkon oluşturur
  Widget _buildIcon(BuildContext context, Color color) {
    // Emoji string ise
    if (icon is String) {
      return Text(
        icon as String,
        style: const TextStyle(fontSize: 32),
      );
    }

    // IconData ise
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        size: 32,
        color: color,
      );
    }

    // Widget ise
    if (icon is Widget) {
      return icon as Widget;
    }

    // Varsayılan
    return Icon(
      Icons.star,
      size: 32,
      color: color,
    );
  }
}
