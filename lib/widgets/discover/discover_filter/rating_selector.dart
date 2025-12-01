import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RatingSelector extends StatelessWidget {
  final Set<int> selectedRatings;
  final void Function(int value, bool wasSelected) onToggle;

  const RatingSelector({
    Key? key,
    required this.selectedRatings,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: local.rating), // Lokalize başlık
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final value = index + 1; // 1..5
            final isSelected = selectedRatings.contains(value);

            return GestureDetector(
              onTap: () => onToggle(value, isSelected),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange[700]
                      : AppColors.ratingStar.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: isSelected ? Colors.white : AppColors.ratingStar,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      value.toStringAsFixed(1), // "1.0" .. "5.0"
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.ratingStar,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
