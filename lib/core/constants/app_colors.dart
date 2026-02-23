import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk sabitleri
///
/// Ana renk paleti Material 3 ColorScheme.fromSeed ile oluşturulur.
/// Bu dosya sadece seed color ve ek yardımcı renkleri içerir.
class AppColors {
  AppColors._(); // Private constructor - utility class

  /// Ana seed color - Warm teal/green (alışkanlık = büyüme)
  ///
  /// Material 3 ColorScheme.fromSeed ile tema oluşturulur
  static const Color seedColor = Color(0xFF26A69A);

  /// Streak göstergesi için gradient başlangıç rengi
  static const Color streakGradientStart = Color(0xFF26A69A);

  /// Streak göstergesi için gradient bitiş rengi
  static const Color streakGradientEnd = Color(0xFF00897B);

  /// Başarı durumu rengi (alışkanlık tamamlandı)
  static const Color success = Color(0xFF4CAF50);

  /// Uyarı durumu rengi (streak tehlikede)
  static const Color warning = Color(0xFFFF9800);

  /// Hata durumu rengi (streak kaybedildi)
  static const Color error = Color(0xFFEF5350);

  /// Bilgi durumu rengi
  static const Color info = Color(0xFF2196F3);

  /// Overlay rengi - light theme
  static const Color overlayLight = Color(0x1F000000);

  /// Overlay rengi - dark theme
  static const Color overlayDark = Color(0x1FFFFFFF);

  /// Divider rengi - light theme
  static const Color dividerLight = Color(0x1F000000);

  /// Divider rengi - dark theme
  static const Color dividerDark = Color(0x1FFFFFFF);

  /// Shimmer effect base color - light theme
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);

  /// Shimmer effect highlight color - light theme
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  /// Shimmer effect base color - dark theme
  static const Color shimmerBaseDark = Color(0xFF424242);

  /// Shimmer effect highlight color - dark theme
  static const Color shimmerHighlightDark = Color(0xFF616161);

  /// Habit icon varsayılan renk listesi
  ///
  /// Kullanıcı alışkanlık oluştururken bu renklerden seçim yapabilir
  static const List<Color> habitColors = [
    Color(0xFF26A69A), // Teal (varsayılan)
    Color(0xFF42A5F5), // Blue
    Color(0xFFEF5350), // Red
    Color(0xFF66BB6A), // Green
    Color(0xFFAB47BC), // Purple
    Color(0xFFFF7043), // Deep Orange
    Color(0xFFFFCA28), // Amber
    Color(0xFF26C6DA), // Cyan
    Color(0xFFEC407A), // Pink
    Color(0xFF7E57C2), // Deep Purple
    Color(0xFF5C6BC0), // Indigo
    Color(0xFF78909C), // Blue Grey
  ];

  /// Calendar heatmap renkleri (düşükten yükseğe)
  ///
  /// GitHub contribution graph tarzı gradient
  static const List<Color> heatmapColors = [
    Color(0xFFE0F2F1), // En düşük - çok açık
    Color(0xFF80CBC4), // Düşük
    Color(0xFF4DB6AC), // Orta
    Color(0xFF26A69A), // Yüksek
    Color(0xFF00897B), // En yüksek - koyu
  ];
}
