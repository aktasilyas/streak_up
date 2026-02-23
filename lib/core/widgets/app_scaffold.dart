import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/widgets/responsive_builder.dart';

/// Uygulama genelinde kullanılan scaffold widget
///
/// SafeArea, responsive padding ve banner ad alanı desteği içerir
class AppScaffold extends StatelessWidget {
  /// App scaffold constructor
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.showBannerAd = false,
    this.bannerAdWidget,
    this.useSafeArea = true,
    this.useResponsivePadding = true,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  /// App bar
  final PreferredSizeWidget? appBar;

  /// Body widget
  final Widget body;

  /// Floating action button
  final Widget? floatingActionButton;

  /// FAB konumu
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Drawer
  final Widget? drawer;

  /// End drawer
  final Widget? endDrawer;

  /// Banner ad gösterilsin mi?
  final bool showBannerAd;

  /// Banner ad widget (custom ad widget kullanılacaksa)
  final Widget? bannerAdWidget;

  /// SafeArea kullanılsın mı?
  final bool useSafeArea;

  /// Responsive padding kullanılsın mı?
  final bool useResponsivePadding;

  /// Background color
  final Color? backgroundColor;

  /// Resize to avoid bottom inset (klavye açıldığında)
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    // Body'yi responsive padding ile sarmala
    Widget bodyWidget = body;

    if (useResponsivePadding) {
      bodyWidget = ResponsivePadding(
        child: bodyWidget,
      );
    }

    // SafeArea ekle
    if (useSafeArea) {
      bodyWidget = SafeArea(
        child: bodyWidget,
      );
    }

    // Banner ad varsa body'nin altına ekle
    if (showBannerAd) {
      bodyWidget = Column(
        children: [
          Expanded(child: bodyWidget),
          _buildBannerAdContainer(context),
        ],
      );
    }

    return Scaffold(
      appBar: appBar,
      body: bodyWidget,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  /// Banner ad container oluşturur
  Widget _buildBannerAdContainer(BuildContext context) {
    return Container(
      height: AppDimensions.bannerAdHeight,
      padding: const EdgeInsets.all(AppDimensions.bannerAdPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: AppDimensions.dividerThickness,
          ),
        ),
      ),
      child: bannerAdWidget ??
          Center(
            child: Text(
              'Ad Space',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
    );
  }
}

/// Scrollable scaffold - içeriği scroll edilebilir yapar
///
/// SingleChildScrollView ile sarmalanmış body içerir
class ScrollableScaffold extends StatelessWidget {
  /// Scrollable scaffold constructor
  const ScrollableScaffold({
    super.key,
    this.appBar,
    required this.children,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.showBannerAd = false,
    this.bannerAdWidget,
    this.useSafeArea = true,
    this.useResponsivePadding = true,
    this.backgroundColor,
    this.scrollPadding,
    this.scrollPhysics,
  });

  /// App bar
  final PreferredSizeWidget? appBar;

  /// Body children
  final List<Widget> children;

  /// Floating action button
  final Widget? floatingActionButton;

  /// FAB konumu
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Drawer
  final Widget? drawer;

  /// End drawer
  final Widget? endDrawer;

  /// Banner ad gösterilsin mi?
  final bool showBannerAd;

  /// Banner ad widget
  final Widget? bannerAdWidget;

  /// SafeArea kullanılsın mı?
  final bool useSafeArea;

  /// Responsive padding kullanılsın mı?
  final bool useResponsivePadding;

  /// Background color
  final Color? backgroundColor;

  /// Scroll padding
  final EdgeInsetsGeometry? scrollPadding;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        physics: scrollPhysics,
        padding: scrollPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      showBannerAd: showBannerAd,
      bannerAdWidget: bannerAdWidget,
      useSafeArea: useSafeArea,
      useResponsivePadding: useResponsivePadding,
      backgroundColor: backgroundColor,
    );
  }
}
