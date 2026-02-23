import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// Tek bir onboarding sayfası widget'ı
///
/// Icon, başlık ve açıklama gösterir.
/// PageView içinde kullanılmak üzere tasarlanmıştır.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  /// Ana ikon
  final IconData icon;

  /// Sayfa başlığı
  final String title;

  /// Açıklama metni
  final String description;

  /// Vurgu rengi
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Büyük ikon — renkli container içinde
          Container(
            width: AppDimensions.iconXxl * 2,
            height: AppDimensions.iconXxl * 2,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconXxl,
              color: color,
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXl),

          // Başlık
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Açıklama
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
