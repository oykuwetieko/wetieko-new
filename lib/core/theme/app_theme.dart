import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.onboardingBackground,
      fontFamily: 'SFPro', 
      textTheme: const TextTheme(
        headline1: AppTextStyles.onboardingTitle,
        subtitle1: AppTextStyles.onboardingSubtitle,
        button: AppTextStyles.buttonText,
        bodyText1: AppTextStyles.textFieldText,
        caption: AppTextStyles.privacyText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle: AppTextStyles.textFieldText.copyWith(
          color: AppColors.textFieldText.withOpacity(0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.onboardingButtonBackground,
          foregroundColor: AppColors.onboardingButtonText,
          textStyle: AppTextStyles.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
