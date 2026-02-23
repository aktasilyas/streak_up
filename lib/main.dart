import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/theme/app_theme.dart';
import 'package:streak_up/features/settings/presentation/providers/settings_provider.dart';
import 'package:streak_up/router/app_router.dart';
import 'package:streak_up/services/ad_service.dart';
import 'package:streak_up/services/analytics_service.dart';
import 'package:streak_up/services/database_service.dart';
import 'package:streak_up/services/notification_service.dart';

/// Uygulama giriş noktası
///
/// Servisleri başlatır ve ProviderScope ile Riverpod'u aktifleştirir.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Servisleri başlat (paralel)
  await Future.wait([
    DatabaseService.instance.database,
    AdService.instance.initialize(),
    NotificationService.instance.initialize(),
    AnalyticsService.instance.initialize(),
  ]);

  runApp(
    const ProviderScope(
      child: StreakUpApp(),
    ),
  );
}

/// StreakUp ana uygulama widget'ı
///
/// Material 3 tema ve GoRouter ile yapılandırılmış.
/// Light/Dark tema desteği — settingsProvider'dan okunur.
class StreakUpApp extends ConsumerWidget {
  const StreakUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema modunu settings provider'dan dinle
    final themeMode = ref.watch(
      settingsProvider.select((s) => s.themeMode),
    );

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Tema
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Router
      routerConfig: AppRouter.router,
    );
  }
}
