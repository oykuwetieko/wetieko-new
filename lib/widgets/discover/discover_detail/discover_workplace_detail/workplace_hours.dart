import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/place_hours_extension.dart'; 

class WorkplaceHours extends StatelessWidget {
  final List<String> weekdayText;

  const WorkplaceHours({
    super.key,
    required this.weekdayText,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    const defaultHours = '08:30 - 22:00';

    final weekdayRange = weekdayText.getWeekdayHours();
    final weekendRange = weekdayText.getWeekendHours();

    final weekdayFormatted = weekdayRange?.trim().isNotEmpty == true ? weekdayRange! : defaultHours;
    final weekendFormatted = weekendRange?.trim().isNotEmpty == true ? weekendRange! : defaultHours;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutralGrey.withOpacity(0.8),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: AppColors.onboardingTitle),
              const SizedBox(width: 6),
              Text(
                local.workingHours,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoLine(local.weekday, weekdayFormatted),
          const SizedBox(height: 10),
          _infoLine(local.weekend, weekendFormatted),
        ],
      ),
    );
  }

  static Widget _infoLine(String label, String time) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.neutralGrey.withOpacity(0.4),
                  width: 0.6,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onboardingSubtitle,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
