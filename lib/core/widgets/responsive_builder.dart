import 'package:flutter/material.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';

/// Responsive tasarım için widget builder
///
/// Ekran boyutuna göre farklı layout'lar oluşturulmasını sağlar.
/// Compact, medium ve expanded breakpoint'leri destekler.
class ResponsiveBuilder extends StatelessWidget {
  /// Responsive builder constructor
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  /// Builder fonksiyonu
  ///
  /// [context] ve [constraints] parametreleri alır.
  /// Constraints üzerinden ekran boyutuna göre layout oluşturulur.
  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

/// Breakpoint'e göre farklı widget döndüren responsive builder
///
/// Compact, medium ve expanded ekranlar için ayrı widget'lar belirtilebilir.
class ResponsiveLayout extends StatelessWidget {
  /// Responsive layout constructor
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  /// Compact ekran widget'ı (< 600dp)
  ///
  /// Telefon portrait mode
  final Widget compact;

  /// Medium ekran widget'ı (600 - 840dp)
  ///
  /// Telefon landscape, tablet portrait. Null ise compact kullanılır.
  final Widget? medium;

  /// Expanded ekran widget'ı (> 840dp)
  ///
  /// Tablet landscape, desktop. Null ise medium veya compact kullanılır.
  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Expanded breakpoint
        if (context.isExpanded) {
          return expanded ?? medium ?? compact;
        }

        // Medium breakpoint
        if (context.isMedium) {
          return medium ?? compact;
        }

        // Compact breakpoint (varsayılan)
        return compact;
      },
    );
  }
}

/// Breakpoint'e göre değer döndüren yardımcı sınıf
///
/// Widget yerine değer döndürür (padding, column count, vb.)
class ResponsiveValue<T> {
  /// Responsive value constructor
  const ResponsiveValue({
    required this.compact,
    this.medium,
    this.expanded,
  });

  /// Compact değer
  final T compact;

  /// Medium değer (null ise compact kullanılır)
  final T? medium;

  /// Expanded değer (null ise medium veya compact kullanılır)
  final T? expanded;

  /// Context'e göre uygun değeri döndürür
  T value(BuildContext context) {
    if (context.isExpanded) {
      return expanded ?? medium ?? compact;
    }

    if (context.isMedium) {
      return medium ?? compact;
    }

    return compact;
  }
}

/// Responsive grid için yardımcı sınıf
///
/// Ekran boyutuna göre column sayısı ve spacing değerleri hesaplar
class ResponsiveGrid {
  ResponsiveGrid._(); // Private constructor - utility class

  /// Ekran boyutuna göre column sayısı
  ///
  /// Compact: 1, Medium: 2, Expanded: 3
  static int columnCount(BuildContext context) {
    return context.gridColumnCount;
  }

  /// Ekran boyutuna göre item width
  ///
  /// Grid item'larının genişliğini hesaplar
  static double itemWidth(
    BuildContext context, {
    required int columns,
    required double spacing,
    required double padding,
  }) {
    final screenWidth = context.screenWidth;
    final totalPadding = padding * 2;
    final totalSpacing = spacing * (columns - 1);
    final availableWidth = screenWidth - totalPadding - totalSpacing;
    return availableWidth / columns;
  }

  /// Ekran boyutuna göre aspect ratio
  ///
  /// Grid item'larının en-boy oranını döndürür
  static double aspectRatio(BuildContext context) {
    if (context.isCompact) return 1.0; // Kare
    if (context.isMedium) return 1.2; // Biraz geniş
    return 1.5; // Geniş
  }
}

/// Responsive padding için yardımcı widget
///
/// Ekran boyutuna göre farklı padding değerleri uygular
class ResponsivePadding extends StatelessWidget {
  /// Responsive padding constructor
  const ResponsivePadding({
    super.key,
    required this.child,
    this.compact = 16.0,
    this.medium = 24.0,
    this.expanded = 32.0,
  });

  /// Child widget
  final Widget child;

  /// Compact padding
  final double compact;

  /// Medium padding
  final double? medium;

  /// Expanded padding
  final double? expanded;

  @override
  Widget build(BuildContext context) {
    double padding = compact;

    if (context.isExpanded) {
      padding = expanded ?? medium ?? compact;
    } else if (context.isMedium) {
      padding = medium ?? compact;
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

/// Responsive center widget
///
/// Çok geniş ekranlarda içeriği maksimum genişlikte merkezde tutar
class ResponsiveCenter extends StatelessWidget {
  /// Responsive center constructor
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
  });

  /// Child widget
  final Widget child;

  /// Maksimum genişlik (null ise context.contentMaxWidth kullanılır)
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? context.contentMaxWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}
