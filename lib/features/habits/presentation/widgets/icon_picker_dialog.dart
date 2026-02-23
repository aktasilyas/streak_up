import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';

/// İkon seçici dialog
///
/// Emoji/ikon seçimi için kullanılır
class IconPickerDialog extends StatefulWidget {
  /// Constructor
  const IconPickerDialog({
    super.key,
    required this.selectedIcon,
  });

  /// Seçili ikon
  final String selectedIcon;

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  String? _selectedIcon;

  /// Preset ikonlar
  static const List<String> _icons = [
    '✅', '💪', '🏃', '🧘', '📖', '✍️', '💻', '🎨',
    '🎵', '🎸', '📚', '🌟', '💡', '☕', '💧', '🥗',
    '🍎', '🥤', '😴', '🛌', '🧹', '🏠', '🚿', '🪥',
    '💊', '🩺', '🌱', '🌻', '🌞', '🌙', '⭐', '🎯',
    '🔥', '💚', '🙏', '📝', '📱', '🎮', '📺', '🚫',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.isCompact ? double.infinity : 400,
          maxHeight: context.screenHeight * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildIconGrid(context),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        children: [
          Text(AppStrings.habitFormIconLabel, style: context.titleLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: AppDimensions.paddingS,
        mainAxisSpacing: AppDimensions.paddingS,
        childAspectRatio: 1,
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        final icon = _icons[index];
        final isSelected = icon == _selectedIcon;

        return InkWell(
          onTap: () => setState(() => _selectedIcon = icon),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colorScheme.primaryContainer
                  : context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: isSelected
                  ? Border.all(color: context.colorScheme.primary, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          FilledButton(
            onPressed: _selectedIcon != null
                ? () => Navigator.of(context).pop(_selectedIcon)
                : null,
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}
