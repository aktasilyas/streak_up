import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// Boş state göstergesi widget
///
/// Liste boş olduğunda veya veri olmadığında gösterilir
class EmptyStateWidget extends StatelessWidget {
  /// Empty state widget constructor
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionButton,
    this.actionLabel,
    this.onActionPressed,
    this.iconSize,
  });

  /// İkon (emoji veya IconData)
  final dynamic icon;

  /// Başlık
  final String title;

  /// Açıklama mesajı
  final String message;

  /// Aksiyon butonu widget'ı (custom buton için)
  final Widget? actionButton;

  /// Aksiyon buton etiketi
  final String? actionLabel;

  /// Aksiyon buton callback
  final VoidCallback? onActionPressed;

  /// İkon boyutu
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(context),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null || (actionLabel != null && onActionPressed != null)) ...[
              const SizedBox(height: AppDimensions.paddingL),
              actionButton ?? _buildActionButton(context),
            ],
          ],
        ),
      ),
    );
  }

  /// İkon oluşturur (emoji veya IconData)
  Widget _buildIcon(BuildContext context) {
    final size = iconSize ?? AppDimensions.iconXxl;

    // Emoji string ise
    if (icon is String) {
      return Text(
        icon as String,
        style: TextStyle(fontSize: size),
      );
    }

    // IconData ise
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        size: size,
        color: Theme.of(context).colorScheme.primary,
      );
    }

    // Widget ise
    if (icon is Widget) {
      return icon as Widget;
    }

    // Varsayılan icon
    return Icon(
      Icons.info_outline,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Aksiyon butonu oluşturur
  Widget _buildActionButton(BuildContext context) {
    return FilledButton(
      onPressed: onActionPressed,
      child: Text(actionLabel!),
    );
  }
}

/// Liste için boş state widget
///
/// Liste boşken gösterilir
class ListEmptyState extends StatelessWidget {
  /// List empty state constructor
  const ListEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = '📋',
    this.actionLabel,
    this.onActionPressed,
  });

  /// Başlık
  final String title;

  /// Açıklama mesajı
  final String message;

  /// İkon
  final dynamic icon;

  /// Aksiyon buton etiketi
  final String? actionLabel;

  /// Aksiyon buton callback
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}

/// Search için boş state widget
///
/// Arama sonucu bulunamadığında gösterilir
class SearchEmptyState extends StatelessWidget {
  /// Search empty state constructor
  const SearchEmptyState({
    super.key,
    this.searchQuery,
    this.onClearSearch,
  });

  /// Arama sorgusu
  final String? searchQuery;

  /// Arama temizle callback
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: '🔍',
      title: 'Sonuç Bulunamadı',
      message: searchQuery != null
          ? '"$searchQuery" için sonuç bulunamadı.'
          : 'Arama kriterlerinize uygun sonuç bulunamadı.',
      actionLabel: onClearSearch != null ? 'Aramayı Temizle' : null,
      onActionPressed: onClearSearch,
    );
  }
}

/// Error state widget
///
/// Hata durumunda gösterilir
class ErrorStateWidget extends StatelessWidget {
  /// Error state widget constructor
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Tekrar Dene',
  });

  /// Hata mesajı
  final String message;

  /// Tekrar dene callback
  final VoidCallback? onRetry;

  /// Tekrar dene buton etiketi
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Bir Hata Oluştu',
      message: message,
      actionLabel: onRetry != null ? retryLabel : null,
      onActionPressed: onRetry,
    );
  }
}

/// No connection state widget
///
/// İnternet bağlantısı olmadığında gösterilir
class NoConnectionState extends StatelessWidget {
  /// No connection state constructor
  const NoConnectionState({
    super.key,
    this.onRetry,
  });

  /// Tekrar dene callback
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'Bağlantı Yok',
      message: 'İnternet bağlantınızı kontrol edin ve tekrar deneyin.',
      actionLabel: onRetry != null ? 'Tekrar Dene' : null,
      onActionPressed: onRetry,
    );
  }
}
