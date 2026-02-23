import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/core/extensions/context_extensions.dart';
import 'package:streak_up/core/widgets/app_scaffold.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_form_notifier.dart';
import 'package:streak_up/features/habits/presentation/providers/habit_list_notifier.dart';
import 'package:streak_up/features/habits/presentation/widgets/icon_picker_dialog.dart';
import 'package:streak_up/features/habits/presentation/widgets/color_picker_dialog.dart';

/// Alışkanlık formu ekranı
///
/// Yeni alışkanlık ekleme ve düzenleme için kullanılır
class HabitFormScreen extends ConsumerStatefulWidget {
  /// Constructor
  const HabitFormScreen({
    super.key,
    this.habit,
  });

  /// Düzenlenen alışkanlık (null ise yeni ekleme modu)
  final Habit? habit;

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Edit mode ise form alanlarını doldur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.habit != null) {
        ref.read(habitFormProvider.notifier).loadFromHabit(widget.habit!);
        _nameController.text = widget.habit!.name;
        _descriptionController.text = widget.habit!.description ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(habitFormProvider);
    final isEditMode = widget.habit != null;

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          isEditMode
              ? AppStrings.habitFormTitleEdit
              : AppStrings.habitFormTitleCreate,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: formState.canSubmit ? _saveHabit : null,
            tooltip: AppStrings.save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (formState.errorMessage != null) ...[
                _buildErrorMessage(formState.errorMessage!),
                const SizedBox(height: AppDimensions.paddingM),
              ],
              _buildNameField(),
              const SizedBox(height: AppDimensions.paddingM),
              _buildDescriptionField(),
              const SizedBox(height: AppDimensions.paddingL),
              _buildIconAndColorPicker(formState),
              const SizedBox(height: AppDimensions.paddingL),
              _buildFrequencySelector(formState),
              if (formState.frequency != HabitFrequency.daily) ...[
                const SizedBox(height: AppDimensions.paddingM),
                _buildTargetDaysSelector(formState),
              ],
              const SizedBox(height: AppDimensions.paddingL),
              _buildReminderTimePicker(formState),
              const SizedBox(height: AppDimensions.paddingXl),
              _buildSaveButton(formState),
            ],
          ),
        ),
      ),
    );
  }

  /// Hata mesajı
  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colorScheme.error),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              message,
              style: context.bodyMedium?.copyWith(
                color: context.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// İsim alanı
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: AppStrings.habitFormNameLabel,
        hintText: AppStrings.habitFormNameHint,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.habitFormNameError;
        }
        return null;
      },
      onChanged: (value) {
        ref.read(habitFormProvider.notifier).setName(value);
      },
    );
  }

  /// Açıklama alanı
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: AppStrings.habitFormDescriptionLabel,
        hintText: AppStrings.habitFormDescriptionHint,
      ),
      maxLines: 3,
      onChanged: (value) {
        ref.read(habitFormProvider.notifier).setDescription(value);
      },
    );
  }

  /// İkon ve renk seçici
  Widget _buildIconAndColorPicker(HabitFormState formState) {
    return Row(
      children: [
        Expanded(
          child: _buildIconPicker(formState),
        ),
        const SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildColorPicker(formState),
        ),
      ],
    );
  }

  /// İkon seçici
  Widget _buildIconPicker(HabitFormState formState) {
    return InkWell(
      onTap: () async {
        final icon = await showDialog<String>(
          context: context,
          builder: (context) => IconPickerDialog(
            selectedIcon: formState.icon,
          ),
        );
        if (icon != null) {
          ref.read(habitFormProvider.notifier).setIcon(icon);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Text(
              formState.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              AppStrings.habitFormIconLabel,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renk seçici
  Widget _buildColorPicker(HabitFormState formState) {
    return InkWell(
      onTap: () async {
        final color = await showDialog<int>(
          context: context,
          builder: (context) => ColorPickerDialog(
            selectedColor: formState.color,
          ),
        );
        if (color != null) {
          ref.read(habitFormProvider.notifier).setColor(color);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(formState.color),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              AppStrings.habitFormColorLabel,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sıklık seçici
  Widget _buildFrequencySelector(HabitFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.habitFormFrequencyLabel,
          style: context.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        SegmentedButton<HabitFrequency>(
          segments: const [
            ButtonSegment(
              value: HabitFrequency.daily,
              label: Text(AppStrings.habitFormFrequencyDaily),
            ),
            ButtonSegment(
              value: HabitFrequency.weekly,
              label: Text(AppStrings.habitFormFrequencyWeekly),
            ),
            ButtonSegment(
              value: HabitFrequency.custom,
              label: Text(AppStrings.habitFormFrequencyCustom),
            ),
          ],
          selected: {formState.frequency},
          onSelectionChanged: (Set<HabitFrequency> selection) {
            ref
                .read(habitFormProvider.notifier)
                .setFrequency(selection.first);
          },
        ),
      ],
    );
  }

  /// Hedef günler seçici
  Widget _buildTargetDaysSelector(HabitFormState formState) {
    const days = [
      (1, AppStrings.habitFormDayMonday),
      (2, AppStrings.habitFormDayTuesday),
      (3, AppStrings.habitFormDayWednesday),
      (4, AppStrings.habitFormDayThursday),
      (5, AppStrings.habitFormDayFriday),
      (6, AppStrings.habitFormDaySaturday),
      (7, AppStrings.habitFormDaySunday),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.habitFormTargetDaysLabel,
          style: context.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Wrap(
          spacing: AppDimensions.paddingS,
          runSpacing: AppDimensions.paddingS,
          children: days.map((day) {
            final isSelected = formState.targetDays.contains(day.$1);
            return FilterChip(
              label: Text(day.$2),
              selected: isSelected,
              onSelected: (_) {
                ref.read(habitFormProvider.notifier).toggleTargetDay(day.$1);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Hatırlatma saati seçici
  Widget _buildReminderTimePicker(HabitFormState formState) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        AppStrings.habitFormReminderLabel,
        style: context.titleMedium,
      ),
      subtitle: Text(
        formState.reminderTime ?? AppStrings.habitFormReminderNone,
      ),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          final timeString =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          ref.read(habitFormProvider.notifier).setReminderTime(timeString);
        }
      },
    );
  }

  /// Kaydet butonu
  Widget _buildSaveButton(HabitFormState formState) {
    return FilledButton(
      onPressed: formState.canSubmit && !formState.isSubmitting
          ? _saveHabit
          : null,
      child: formState.isSubmitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              widget.habit != null
                  ? AppStrings.habitFormUpdateButton
                  : AppStrings.habitFormCreateButton,
            ),
    );
  }

  /// Alışkanlığı kaydet
  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(habitFormProvider.notifier);
    final bool success;

    if (widget.habit != null) {
      success = await notifier.updateHabit(widget.habit!.id!);
    } else {
      success = await notifier.createHabit();
    }

    if (!mounted) return;

    if (success) {
      // Listeyi yenile
      await ref.read(habitListProvider.notifier).refresh();

      if (mounted) {
        context.showSuccessSnackBar(
          widget.habit != null
              ? AppStrings.habitFormSuccessUpdate
              : AppStrings.habitFormSuccessCreate,
        );
        Navigator.of(context).pop();
      }
    }
  }
}
