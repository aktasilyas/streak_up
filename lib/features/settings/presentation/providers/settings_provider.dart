import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ayarlar state model'i
///
/// SharedPreferences'ta kalıcı olarak saklanır.
class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.notificationsEnabled,
  });

  /// Tema modu: system, light, dark
  final ThemeMode themeMode;

  /// Bildirimler aktif mi?
  final bool notificationsEnabled;

  /// Copy with metodu — immutable state güncellemesi için
  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

/// Ayarlar state notifier
///
/// SharedPreferences ile persist eder.
/// Theme değişikliği ve bildirim ayarlarını yönetir.
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(const SettingsState(
          themeMode: ThemeMode.system,
          notificationsEnabled: true,
        )) {
    _loadSettings();
  }

  // SharedPreferences anahtarları
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';

  /// Ayarları SharedPreferences'tan yükler
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_keyThemeMode) ?? ThemeMode.system.index;
    final notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;

    state = SettingsState(
      themeMode: ThemeMode.values[themeModeIndex],
      notificationsEnabled: notificationsEnabled,
    );
  }

  /// Tema modunu değiştirir
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  /// Bildirimleri aç/kapat
  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, newValue);
    state = state.copyWith(notificationsEnabled: newValue);
  }
}

/// Settings provider — global state
///
/// Uygulama genelinde kullanılır.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
