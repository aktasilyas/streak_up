import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/features/settings/presentation/providers/settings_provider.dart';
import 'package:streak_up/features/settings/presentation/widgets/theme_selector.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ayarlar ekranı
///
/// Tema, bildirimler, veri yönetimi, hakkında bölümlerini içerir.
/// ListTile grupları ile düzenlenmiş responsive layout.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  /// Uygulama versiyonunu yükler
  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsEnabled = ref.watch(
      settingsProvider.select((s) => s.notificationsEnabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: ListView(
        children: [
          // Görünüm bölümü
          _buildSectionHeader(context, AppStrings.settingsSectionAppearance),
          _buildThemeSection(),
          const Divider(),

          // Bildirimler bölümü
          _buildSectionHeader(context, AppStrings.settingsSectionNotifications),
          _buildNotificationToggle(notificationsEnabled),
          const Divider(),

          // Veri bölümü
          _buildSectionHeader(context, AppStrings.settingsSectionData),
          _buildDataTile(
            icon: Icons.delete_forever_outlined,
            title: AppStrings.settingsClearData,
            onTap: _showClearDataDialog,
            isDestructive: true,
          ),
          const Divider(),

          // Hakkında bölümü
          _buildSectionHeader(context, AppStrings.settingsSectionAbout),
          _buildAboutTile(
            icon: Icons.info_outline,
            title: AppStrings.settingsVersion,
            trailing: _appVersion,
          ),
          _buildAboutTile(
            icon: Icons.star_outline,
            title: AppStrings.settingsRateApp,
            onTap: _rateApp,
          ),
          _buildAboutTile(
            icon: Icons.privacy_tip_outlined,
            title: AppStrings.settingsPrivacyPolicy,
            onTap: _openPrivacyPolicy,
          ),

          // Alt boşluk — bottom navigation bar ile çakışmasın
          const SizedBox(height: AppDimensions.paddingXxl),
        ],
      ),
    );
  }

  /// Bölüm başlığı widget'ı
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingL,
        AppDimensions.paddingM,
        AppDimensions.paddingS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  /// Tema seçim bölümü
  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text(AppStrings.settingsThemeMode),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingXs,
          ),
        ),
        const ThemeSelector(),
      ],
    );
  }

  /// Bildirim toggle switch'i
  Widget _buildNotificationToggle(bool enabled) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_outlined),
      title: const Text(AppStrings.settingsNotificationsEnabled),
      value: enabled,
      onChanged: (value) {
        ref.read(settingsProvider.notifier).toggleNotifications();
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXs,
      ),
    );
  }

  /// Veri yönetim tile'ı
  Widget _buildDataTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(
        title,
        style: isDestructive
            ? TextStyle(color: Theme.of(context).colorScheme.error)
            : null,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXs,
      ),
    );
  }

  /// Hakkında tile'ı
  Widget _buildAboutTile({
    required IconData icon,
    required String title,
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null
          ? Text(
              trailing,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXs,
      ),
    );
  }

  /// Veri temizleme onay dialog'u
  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.settingsClearDataDialogTitle),
        content: const Text(AppStrings.settingsClearDataDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _clearAllData();
    }
  }

  /// Tüm verileri temizler
  Future<void> _clearAllData() async {
    try {
      // TODO: DatabaseService ile tüm verileri temizle
      // await DatabaseService.instance.clearAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tüm veriler temizlendi'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Uygulamayı değerlendir
  Future<void> _rateApp() async {
    // TODO: Platform'a göre store URL'i aç
    // Android: market://details?id=com.yourcompany.streakup
    // iOS: https://apps.apple.com/app/idXXXXXXXXX
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Değerlendirme özelliği yakında...')),
      );
    }
  }

  /// Gizlilik politikası sayfasını aç
  Future<void> _openPrivacyPolicy() async {
    const url = 'https://yourwebsite.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link açılamadı')),
        );
      }
    }
  }
}
