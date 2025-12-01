import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.nextButton,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.onboardingButtonText,
            size: 24,
          ),
        ),
      ),
    );
  }
}
