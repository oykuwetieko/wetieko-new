import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_info_card.dart';

class WorkplaceRate extends StatefulWidget {
  final void Function(Map<String, int>) onRatingChanged;

  const WorkplaceRate({super.key, required this.onRatingChanged});

  @override
  State<WorkplaceRate> createState() => _WorkplaceRateState();
}

class _WorkplaceRateState extends State<WorkplaceRate> {
  final Map<String, int> _ratings = {
    'wifi': 5,
    'socket': 5,
    'silence': 5,
    'workDesk': 5,
    'lighting': 5,
    'ventilation': 5,
  };

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onRatingChanged(_ratings);
    });
  }

  final Map<int, IconData> levelIcons = {
    1: Icons.sentiment_very_dissatisfied,
    2: Icons.sentiment_dissatisfied,
    3: Icons.sentiment_neutral,
    4: Icons.sentiment_satisfied,
    5: Icons.sentiment_very_satisfied,
  };

  final Map<String, IconData> categoryIcons = {
    'wifi': Icons.wifi,
    'socket': Icons.power_outlined,
    'silence': Icons.volume_off_outlined,
    'workDesk': Icons.chair_outlined,
    'lighting': Icons.light_mode_outlined,
    'ventilation': Icons.ac_unit,
  };

  void _setRating(String key, int value) {
    setState(() => _ratings[key] = value);
    widget.onRatingChanged(_ratings);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final Map<int, String> levelLabels = {
      1: loc.ratingDisaster,
      2: loc.ratingBad,
      3: loc.ratingOkay,
      4: loc.ratingGood,
      5: loc.ratingGreat,
    };

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              loc.workingConditions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDark,
              ),
            ),
          ),
        ),
        WorkplaceRateInfoCard(
          message: loc.workplaceConditionsHint,
        ),
        ..._ratings.entries.map((entry) {
          final key = entry.key;
          final selected = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.neutralGrey.withOpacity(0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      categoryIcons[key],
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _localizedCategoryTitle(key, loc),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final value = index + 1;
                    final isSelected = selected == value;

                    return GestureDetector(
                      onTap: () => _setRating(key, value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 56,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.12)
                              : AppColors.neutralLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              levelIcons[value],
                              size: 22,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.neutralText,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              levelLabels[value]!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.neutralText.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _localizedCategoryTitle(String key, AppLocalizations loc) {
    switch (key) {
      case 'wifi':
        return loc.wifi;
      case 'socket':
        return loc.socket;
      case 'silence':
        return loc.silence;
      case 'workDesk':
        return loc.workDesk;
      case 'lighting':
        return loc.lighting;
      case 'ventilation':
        return loc.ventilation;
      default:
        return key;
    }
  }
}
