/// Uygulama genelinde kullanılan boyut sabitleri
///
/// Hardcoded piksel değerleri kullanımı yasaktır.
/// Tüm padding, margin, radius, icon size değerleri bu sınıfta tanımlanmalıdır.
class AppDimensions {
  AppDimensions._(); // Private constructor - utility class

  // ============================================================================
  // PADDING / MARGIN
  // ============================================================================

  /// Extra small padding: 4.0
  static const double paddingXs = 4.0;

  /// Small padding: 8.0
  static const double paddingS = 8.0;

  /// Medium padding: 16.0 (varsayılan)
  static const double paddingM = 16.0;

  /// Large padding: 24.0
  static const double paddingL = 24.0;

  /// Extra large padding: 32.0
  static const double paddingXl = 32.0;

  /// Extra extra large padding: 48.0
  static const double paddingXxl = 48.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  /// Small radius: 8.0
  static const double radiusS = 8.0;

  /// Medium radius: 12.0 (butonlar için)
  static const double radiusM = 12.0;

  /// Large radius: 16.0 (kartlar için)
  static const double radiusL = 16.0;

  /// Extra large radius: 24.0 (bottom sheet için)
  static const double radiusXl = 24.0;

  /// Circular radius: 999.0 (tamamen yuvarlak)
  static const double radiusCircular = 999.0;

  // ============================================================================
  // ICON SIZE
  // ============================================================================

  /// Small icon: 16.0
  static const double iconS = 16.0;

  /// Medium icon: 24.0 (varsayılan)
  static const double iconM = 24.0;

  /// Large icon: 32.0
  static const double iconL = 32.0;

  /// Extra large icon: 48.0
  static const double iconXl = 48.0;

  /// Extra extra large icon: 64.0
  static const double iconXxl = 64.0;

  // ============================================================================
  // BUTTON
  // ============================================================================

  /// Minimum button height: 48.0 (Material design accessibility)
  static const double buttonMinHeight = 48.0;

  /// Small button height: 36.0
  static const double buttonHeightS = 36.0;

  /// Medium button height: 48.0 (varsayılan)
  static const double buttonHeightM = 48.0;

  /// Large button height: 56.0
  static const double buttonHeightL = 56.0;

  /// Button padding horizontal: 24.0
  static const double buttonPaddingH = 24.0;

  /// Button padding vertical: 12.0
  static const double buttonPaddingV = 12.0;

  // ============================================================================
  // CARD
  // ============================================================================

  /// Card elevation: 2.0 (Material 3'te elevation düşük tutulur)
  static const double cardElevation = 2.0;

  /// Card padding: 16.0
  static const double cardPadding = paddingM;

  /// Card margin: 8.0
  static const double cardMargin = paddingS;

  // ============================================================================
  // APP BAR
  // ============================================================================

  /// App bar height: 56.0
  static const double appBarHeight = 56.0;

  /// App bar elevation: 0.0 (Material 3'te elevation yok)
  static const double appBarElevation = 0.0;

  // ============================================================================
  // BOTTOM NAVIGATION BAR
  // ============================================================================

  /// Bottom navigation bar height: 80.0
  static const double bottomNavBarHeight = 80.0;

  /// Bottom navigation bar elevation: 8.0
  static const double bottomNavBarElevation = 8.0;

  // ============================================================================
  // FAB (Floating Action Button)
  // ============================================================================

  /// FAB size: 56.0
  static const double fabSize = 56.0;

  /// FAB small size: 40.0
  static const double fabSizeSmall = 40.0;

  /// FAB large size: 96.0
  static const double fabSizeLarge = 96.0;

  /// FAB margin bottom: 16.0
  static const double fabMarginBottom = paddingM;

  // ============================================================================
  // INPUT / TEXT FIELD
  // ============================================================================

  /// Text field height: 56.0
  static const double textFieldHeight = 56.0;

  /// Text field border width: 1.0
  static const double textFieldBorderWidth = 1.0;

  /// Text field focused border width: 2.0
  static const double textFieldFocusedBorderWidth = 2.0;

  /// Text field padding horizontal: 16.0
  static const double textFieldPaddingH = paddingM;

  /// Text field padding vertical: 12.0
  static const double textFieldPaddingV = 12.0;

  // ============================================================================
  // DIVIDER
  // ============================================================================

  /// Divider thickness: 1.0
  static const double dividerThickness = 1.0;

  /// Divider indent: 16.0
  static const double dividerIndent = paddingM;

  // ============================================================================
  // LIST TILE
  // ============================================================================

  /// List tile padding horizontal: 16.0
  static const double listTilePaddingH = paddingM;

  /// List tile padding vertical: 8.0
  static const double listTilePaddingV = paddingS;

  /// List tile leading/trailing size: 40.0
  static const double listTileIconSize = 40.0;

  // ============================================================================
  // DIALOG
  // ============================================================================

  /// Dialog border radius: 28.0 (Material 3)
  static const double dialogRadius = 28.0;

  /// Dialog padding: 24.0
  static const double dialogPadding = paddingL;

  /// Dialog min width: 280.0
  static const double dialogMinWidth = 280.0;

  /// Dialog max width: 560.0
  static const double dialogMaxWidth = 560.0;

  // ============================================================================
  // BOTTOM SHEET
  // ============================================================================

  /// Bottom sheet border radius: 24.0
  static const double bottomSheetRadius = radiusXl;

  /// Bottom sheet padding: 24.0
  static const double bottomSheetPadding = paddingL;

  /// Bottom sheet handle width: 32.0
  static const double bottomSheetHandleWidth = 32.0;

  /// Bottom sheet handle height: 4.0
  static const double bottomSheetHandleHeight = 4.0;

  /// Bottom sheet handle margin: 12.0
  static const double bottomSheetHandleMargin = 12.0;

  // ============================================================================
  // BANNER AD
  // ============================================================================

  /// Banner ad height: 60.0 (AdMob standard banner + padding)
  static const double bannerAdHeight = 60.0;

  /// Banner ad container height: 50.0 (AdMob standard banner)
  static const double bannerAdContainerHeight = 50.0;

  /// Banner ad padding: 8.0
  static const double bannerAdPadding = paddingS;

  // ============================================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================================

  /// Compact breakpoint: < 600
  ///
  /// Telefon portrait mode
  static const double breakpointCompact = 600.0;

  /// Medium breakpoint: 600 - 840
  ///
  /// Telefon landscape, tablet portrait
  static const double breakpointMedium = 840.0;

  /// Expanded breakpoint: > 840
  ///
  /// Tablet landscape, desktop
  static const double breakpointExpanded = 840.0;

  /// Maximum content width: 840.0
  ///
  /// Çok geniş ekranlarda içerik merkezde tutulur
  static const double maxContentWidth = 840.0;

  // ============================================================================
  // HABIT SPECIFIC
  // ============================================================================

  /// Habit card height: 120.0
  static const double habitCardHeight = 120.0;

  /// Habit icon container size: 56.0
  static const double habitIconContainerSize = 56.0;

  /// Streak badge size: 40.0
  static const double streakBadgeSize = 40.0;

  /// Check button size: 64.0
  static const double checkButtonSize = 64.0;

  /// Calendar cell size: 40.0
  static const double calendarCellSize = 40.0;

  /// Calendar cell spacing: 4.0
  static const double calendarCellSpacing = paddingXs;

  // ============================================================================
  // ANIMATION
  // ============================================================================

  /// Default animation duration: 300 milliseconds
  static const int animationDurationMs = 300;

  /// Fast animation duration: 150 milliseconds
  static const int animationDurationFastMs = 150;

  /// Slow animation duration: 500 milliseconds
  static const int animationDurationSlowMs = 500;

  // ============================================================================
  // GRID
  // ============================================================================

  /// Grid spacing: 16.0
  static const double gridSpacing = paddingM;

  /// Grid columns compact (telefon): 1
  static const int gridColumnsCompact = 1;

  /// Grid columns medium (tablet portrait): 2
  static const int gridColumnsMedium = 2;

  /// Grid columns expanded (tablet landscape): 3
  static const int gridColumnsExpanded = 3;

  // ============================================================================
  // CHART
  // ============================================================================

  /// Chart height: 200.0
  static const double chartHeight = 200.0;

  /// Chart padding: 16.0
  static const double chartPadding = paddingM;

  /// Chart bar width: 12.0
  static const double chartBarWidth = 12.0;
}
