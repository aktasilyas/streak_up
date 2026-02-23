import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';

/// BuildContext için yardımcı extension metodları
///
/// Tema, renk, metin stilleri ve responsive özelliklere hızlı erişim sağlar
extension ContextExtensions on BuildContext {
  // ==========================================================================
  // THEME
  // ==========================================================================

  /// Mevcut tema verisine erişim
  ThemeData get theme => Theme.of(this);

  /// Mevcut renk paletine erişim
  ColorScheme get colorScheme => theme.colorScheme;

  /// Mevcut metin stillerine erişim
  TextTheme get textTheme => theme.textTheme;

  /// Dark mode aktif mi?
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Light mode aktif mi?
  bool get isLightMode => theme.brightness == Brightness.light;

  // ==========================================================================
  // COLORS (Hızlı erişim)
  // ==========================================================================

  /// Primary color
  Color get primaryColor => colorScheme.primary;

  /// Secondary color
  Color get secondaryColor => colorScheme.secondary;

  /// Background color
  Color get backgroundColor => colorScheme.surface;

  /// Surface color
  Color get surfaceColor => colorScheme.surface;

  /// Error color
  Color get errorColor => colorScheme.error;

  /// On primary color (primary üzerindeki metin rengi)
  Color get onPrimaryColor => colorScheme.onPrimary;

  /// On secondary color
  Color get onSecondaryColor => colorScheme.onSecondary;

  /// On background color
  Color get onBackgroundColor => colorScheme.onSurface;

  /// On surface color
  Color get onSurfaceColor => colorScheme.onSurface;

  /// On error color
  Color get onErrorColor => colorScheme.onError;

  // ==========================================================================
  // TEXT STYLES (Hızlı erişim)
  // ==========================================================================

  /// Display large text style
  TextStyle? get displayLarge => textTheme.displayLarge;

  /// Display medium text style
  TextStyle? get displayMedium => textTheme.displayMedium;

  /// Display small text style
  TextStyle? get displaySmall => textTheme.displaySmall;

  /// Headline large text style
  TextStyle? get headlineLarge => textTheme.headlineLarge;

  /// Headline medium text style
  TextStyle? get headlineMedium => textTheme.headlineMedium;

  /// Headline small text style
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  /// Title large text style
  TextStyle? get titleLarge => textTheme.titleLarge;

  /// Title medium text style
  TextStyle? get titleMedium => textTheme.titleMedium;

  /// Title small text style
  TextStyle? get titleSmall => textTheme.titleSmall;

  /// Body large text style
  TextStyle? get bodyLarge => textTheme.bodyLarge;

  /// Body medium text style
  TextStyle? get bodyMedium => textTheme.bodyMedium;

  /// Body small text style
  TextStyle? get bodySmall => textTheme.bodySmall;

  /// Label large text style
  TextStyle? get labelLarge => textTheme.labelLarge;

  /// Label medium text style
  TextStyle? get labelMedium => textTheme.labelMedium;

  /// Label small text style
  TextStyle? get labelSmall => textTheme.labelSmall;

  // ==========================================================================
  // MEDIA QUERY
  // ==========================================================================

  /// MediaQuery verisi
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ekran boyutu
  Size get screenSize => mediaQuery.size;

  /// Ekran genişliği
  double get screenWidth => screenSize.width;

  /// Ekran yüksekliği
  double get screenHeight => screenSize.height;

  /// Klavye yüksekliği (açıkken)
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Klavye açık mı?
  bool get isKeyboardOpen => keyboardHeight > 0;

  /// Status bar yüksekliği
  double get statusBarHeight => mediaQuery.padding.top;

  /// Bottom safe area yüksekliği
  double get bottomSafeArea => mediaQuery.padding.bottom;

  /// Pixel ratio
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Text scale factor
  double get textScaleFactor => mediaQuery.textScaler.scale(1.0);

  // ==========================================================================
  // RESPONSIVE BREAKPOINTS
  // ==========================================================================

  /// Compact breakpoint (< 600dp) - Telefon
  ///
  /// Telefon portrait mode için optimize edilmiş
  bool get isCompact => screenWidth < AppDimensions.breakpointCompact;

  /// Medium breakpoint (600 - 840dp) - Tablet portrait
  ///
  /// Telefon landscape ve tablet portrait için optimize edilmiş
  bool get isMedium =>
      screenWidth >= AppDimensions.breakpointCompact &&
      screenWidth < AppDimensions.breakpointMedium;

  /// Expanded breakpoint (> 840dp) - Tablet landscape / Desktop
  ///
  /// Tablet landscape ve masaüstü için optimize edilmiş
  bool get isExpanded => screenWidth >= AppDimensions.breakpointExpanded;

  /// Portrait orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  // ==========================================================================
  // RESPONSIVE HELPERS
  // ==========================================================================

  /// Grid column count için responsive değer döndürür
  ///
  /// Compact: 1, Medium: 2, Expanded: 3
  int get gridColumnCount {
    if (isCompact) return AppDimensions.gridColumnsCompact;
    if (isMedium) return AppDimensions.gridColumnsMedium;
    return AppDimensions.gridColumnsExpanded;
  }

  /// Responsive padding değeri döndürür
  ///
  /// Compact: paddingM, Medium: paddingL, Expanded: paddingXl
  double get responsivePadding {
    if (isCompact) return AppDimensions.paddingM;
    if (isMedium) return AppDimensions.paddingL;
    return AppDimensions.paddingXl;
  }

  /// Content max width döndürür (çok geniş ekranlarda içerik merkezde kalır)
  ///
  /// Ekran genişliği maxContentWidth'ten büyükse, maxContentWidth döner
  double get contentMaxWidth {
    return screenWidth > AppDimensions.maxContentWidth
        ? AppDimensions.maxContentWidth
        : screenWidth;
  }

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  /// Navigator'a erişim
  NavigatorState get navigator => Navigator.of(this);

  /// Can pop check
  bool get canPop => navigator.canPop();

  /// Pop route
  void pop<T>([T? result]) => navigator.pop(result);

  // ==========================================================================
  // SNACKBAR / DIALOG HELPERS
  // ==========================================================================

  /// SnackBar göster
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Error SnackBar göster
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Success SnackBar göster
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================================
  // FOCUS
  // ==========================================================================

  /// Klavyeyi kapat (focus'u kaldır)
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Focus request et
  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }
}
