import 'package:flutter/material.dart';
import 'package:streak_up/core/constants/app_colors.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';

/// Renk seçici dialog
///
/// Preset renk paleti gösterir
class ColorPickerDialog extends StatefulWidget {
  /// Constructor
  const ColorPickerDialog({
    super.key,
    required this.selectedColor,
  });

  /// Seçili renk (ARGB)
  final int selectedColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  int? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.isCompact ? double.infinity : 400,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppDimensions.paddingL),
              _buildColorGrid(context),
              const SizedBox(height: AppDimensions.paddingL),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(AppStrings.habitFormColorLabel, style: context.titleLarge),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildColorGrid(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.paddingM,
      runSpacing: AppDimensions.paddingM,
      alignment: WrapAlignment.center,
      children: AppColors.habitColors.map((color) {
        final colorValue = color.toARGB32();
        final isSelected = colorValue == _selectedColor;

        return GestureDetector(
          onTap: () => setState(() => _selectedColor = colorValue),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: AppDimensions.animationDurationMs,
            ),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: context.colorScheme.onSurface, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getContrastColor(color),
                    size: 32,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        FilledButton(
          onPressed: _selectedColor != null
              ? () => Navigator.of(context).pop(_selectedColor)
              : null,
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }

  /// Kontrast renk hesaplar (check icon için)
  Color _getContrastColor(Color color) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;

    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
