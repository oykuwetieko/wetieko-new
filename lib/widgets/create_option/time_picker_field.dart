import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class TimePickerField extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerField({
    super.key,
    required this.onTimeSelected,
  });

  Future<void> _pickTime(BuildContext context) async {
    // Dokunsal geri bildirim
    HapticFeedback.selectionClick();

    final now = TimeOfDay.now();
    final localizations = AppLocalizations.of(context)!;

    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      helpText: localizations.helpText,       
      cancelText: localizations.cancel,       
      confirmText: localizations.select,       
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.neutralDark,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white,
              dialHandColor: AppColors.primary,
              hourMinuteTextColor: AppColors.neutralDark,
              hourMinuteColor: Colors.white,
              dialBackgroundColor: Color(0xFFECEFF1),
              dialTextColor: AppColors.primary,
              entryModeIconColor: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          onTap: () => _pickTime(context),
        ),
      ),
    );
  }
}
