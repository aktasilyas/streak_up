import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/features/settings/presentation/providers/settings_provider.dart';

/// Tema seçici widget
///
/// Sistem/Açık/Koyu seçenekleri ile SegmentedButton.
/// State yönetimi [settingsProvider] ile yapılır.
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment<ThemeMode>(
            value: ThemeMode.system,
            label: Text(AppStrings.settingsThemeSystem),
            icon: Icon(Icons.brightness_auto),
          ),
          ButtonSegment<ThemeMode>(
            value: ThemeMode.light,
            label: Text(AppStrings.settingsThemeLight),
            icon: Icon(Icons.light_mode),
          ),
          ButtonSegment<ThemeMode>(
            value: ThemeMode.dark,
            label: Text(AppStrings.settingsThemeDark),
            icon: Icon(Icons.dark_mode),
          ),
        ],
        selected: {themeMode},
        onSelectionChanged: (Set<ThemeMode> newSelection) {
          ref.read(settingsProvider.notifier).setThemeMode(newSelection.first);
        },
        showSelectedIcon: false,
      ),
    );
  }
}
