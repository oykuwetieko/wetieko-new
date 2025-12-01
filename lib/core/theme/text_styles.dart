import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.onboardingTitle,
  );

  static const TextStyle onboardingSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onboardingSubtitle,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onboardingButtonText,
  );

  static const TextStyle privacyText = TextStyle(
    fontSize: 12,
    color: AppColors.privacyText,
  );

  static const TextStyle textFieldText = TextStyle(
    fontSize: 14,
    color: AppColors.textFieldText,
  );

  static const TextStyle stepBarLabel = TextStyle(
    fontSize: 12,
    color: AppColors.stepBar,
  );
}
