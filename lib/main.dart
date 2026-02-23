import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/theme/app_theme.dart';
import 'package:streak_up/router/app_router.dart';
import 'package:streak_up/services/ad_service.dart';
import 'package:streak_up/services/database_service.dart';

/// Uygulama giriş noktası
///
/// Servisleri başlatır ve ProviderScope ile Riverpod'u aktifleştirir.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Servisleri başlat (paralel)
  await Future.wait([
    DatabaseService.instance.database,
    AdService.instance.initialize(),
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
/// Light/Dark tema desteği — sistem temasını takip eder.
class StreakUpApp extends StatelessWidget {
  const StreakUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Tema
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // Router
      routerConfig: AppRouter.router,
    );
  }
}
