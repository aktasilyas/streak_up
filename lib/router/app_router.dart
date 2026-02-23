import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/features/habits/presentation/screens/habit_list_screen.dart';
import 'package:streak_up/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:streak_up/features/settings/presentation/screens/settings_screen.dart';
import 'package:streak_up/features/statistics/presentation/screens/stats_screen.dart';

/// Uygulama yönlendirme tanımları — GoRouter
///
/// ShellRoute ile bottom navigation bar destekli.
/// Tüm route path'leri [AppRoutes] sabitlerinde tanımlıdır.
class AppRouter {
  AppRouter._();

  /// Navigasyon anahtarları — ShellRoute için
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Onboarding tamamlanma key'i
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// GoRouter instance'ı
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.onboarding,
    redirect: (context, state) async {
      // Onboarding tamamlanmış mı kontrol et
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingCompleted =
          prefs.getBool(_keyOnboardingCompleted) ?? false;
      final isOnOnboardingPage = state.uri.path == AppRoutes.onboarding;

      // Onboarding tamamlanmışsa ve onboarding sayfasındaysa ana sayfaya yönlendir
      if (isOnboardingCompleted && isOnOnboardingPage) {
        return AppRoutes.habits;
      }

      // Onboarding tamamlanmamışsa ve başka bir sayfadaysa onboarding'e yönlendir
      if (!isOnboardingCompleted && !isOnOnboardingPage) {
        return AppRoutes.onboarding;
      }

      return null; // Yönlendirme yapma
    },
    routes: [
      // Onboarding — ilk kullanım ekranı
      GoRoute(
        path: AppRoutes.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      // Ana ekranlar — Bottom navigation ile
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.habits,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HabitListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.stats,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // Tam ekran sayfalar — Bottom navigation olmadan
      GoRoute(
        path: AppRoutes.addHabit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const _PlaceholderScreen(
          title: AppStrings.habitFormTitleCreate,
        ),
      ),
      GoRoute(
        path: '${AppRoutes.editHabit}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _PlaceholderScreen(
            title: '${AppStrings.habitFormTitleEdit} #$id',
          );
        },
      ),
    ],
  );
}

/// Uygulama route path sabitleri
///
/// Hardcoded string kullanımını önler
class AppRoutes {
  AppRoutes._();

  /// Onboarding — ilk kullanım
  static const String onboarding = '/onboarding';

  /// Ana sayfa — Alışkanlık listesi
  static const String habits = '/';

  /// İstatistikler ekranı
  static const String stats = '/stats';

  /// Ayarlar ekranı
  static const String settings = '/settings';

  /// Yeni alışkanlık oluşturma
  static const String addHabit = '/add';

  /// Alışkanlık düzenleme (path parameter: id)
  static const String editHabit = '/edit';
}

// =============================================================================
// SHELL SCAFFOLD — Bottom Navigation Bar
// =============================================================================

/// Bottom navigation bar ile sarılmış ana iskelet
///
/// ShellRoute tarafından kullanılır.
/// Gerçek screen'ler oluşturulunca buradan kaldırılabilir.
class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: AppStrings.navHabits,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppStrings.navStatistics,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: AppStrings.navSettings,
          ),
        ],
      ),
    );
  }

  /// Mevcut route'a göre seçili tab index'ini hesaplar
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.stats)) return 1;
    if (location.startsWith(AppRoutes.settings)) return 2;
    return 0;
  }

  /// Tab'a basıldığında ilgili route'a yönlendirir
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.habits);
      case 1:
        context.go(AppRoutes.stats);
      case 2:
        context.go(AppRoutes.settings);
    }
  }
}

// =============================================================================
// PLACEHOLDER — Gerçek ekranlar hazır olana kadar
// =============================================================================

/// Geçici placeholder ekran
///
/// Gerçek screen widget'ları oluşturulunca kaldırılacak.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
