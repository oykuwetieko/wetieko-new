import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/11_terms_use_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/10_privacy_policy_screen.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Text.rich(
      TextSpan(
        text: '${locale.termsText.split(locale.termsOfService).first}',
        style: AppTextStyles.privacyText,
        children: [
          TextSpan(
            text: locale.termsOfService,
            style: AppTextStyles.privacyText.copyWith(
              decoration: TextDecoration.underline,
              color: AppColors.onboardingTitle,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsUseScreen(),
                  ),
                );
              },
          ),
          TextSpan(
            text:
                ' ${locale.termsText.split(locale.privacyPolicy).first.split(locale.termsOfService).last.trim()} ',
            style: AppTextStyles.privacyText,
          ),
          TextSpan(
            text: locale.privacyPolicy,
            style: AppTextStyles.privacyText.copyWith(
              decoration: TextDecoration.underline,
              color: AppColors.onboardingTitle,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
