import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkplaceRateButton extends StatelessWidget {
  final VoidCallback onTap;

  const WorkplaceRateButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return CustomButton(
      text: local.rateNow, 
      onPressed: onTap,
      icon: Icons.rate_review,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }
}
