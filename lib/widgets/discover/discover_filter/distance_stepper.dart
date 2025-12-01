import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DistanceStepper extends StatelessWidget {
  final double distance;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const DistanceStepper({
    Key? key,
    required this.distance,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: local.distance), // Lokalize başlık
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _roundedButton(Icons.remove, onDecrease),
            Text(
              "${distance.round()} km",
              style: AppTextStyles.textFieldText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _roundedButton(Icons.add, onIncrease),
          ],
        ),
      ],
    );
  }

  Widget _roundedButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.categoryInactiveBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.textFieldText),
      ),
    );
  }
}
