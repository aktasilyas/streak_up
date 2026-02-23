import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/services/ad_service.dart';

/// Streak kurtarma dialog'u — StatefulWidget (reklam lifecycle icin istisna)
///
/// Rewarded video ile streak kurtarma imkani sunar.
/// Dialog sonucu: true (streak kurtarildi), false/null (vazgecildi).
class StreakRescueDialog extends StatefulWidget {
  /// Constructor
  const StreakRescueDialog({super.key});

  @override
  State<StreakRescueDialog> createState() => _StreakRescueDialogState();
}

class _StreakRescueDialogState extends State<StreakRescueDialog> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Rewarded video onceden yukle
    AdService.instance.loadRewarded();
  }

  /// Reklam izle ve streak kurtar
  Future<void> _watchAdAndRescue() async {
    setState(() => _isLoading = true);

    final result = await AdService.instance.showRewarded();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result) {
      // Basarili — dialog'u true ile kapat
      Navigator.of(context).pop(true);
    } else {
      // Basarisiz — hata mesaji goster
      context.showErrorSnackBar(AppStrings.streakRescueFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(context),
      content: Text(
        AppStrings.streakRescueMessage,
        style: context.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.streakRescueSkip),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _watchAdAndRescue,
          icon: _isLoading
              ? const SizedBox(
                  width: AppDimensions.iconS,
                  height: AppDimensions.iconS,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_circle_outline),
          label: Text(
            _isLoading
                ? AppStrings.loading
                : AppStrings.streakRescueButton,
          ),
        ),
      ],
    );
  }

  /// Dialog basligini olusturur
  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          '\u{1F525}',
          style: TextStyle(fontSize: 28),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: Text(
            AppStrings.streakRescueTitle,
            style: context.titleLarge,
          ),
        ),
      ],
    );
  }
}
