import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.privacyPolicy,
        showStepBar: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.privacySectionIntroTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionIntroBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionDataUsageTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionDataUsageBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionDataSharingTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionDataSharingBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionSecurityTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionSecurityBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionUserRightsTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionUserRightsBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionDisclaimerTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionDisclaimerBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionChangesTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionChangesBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.privacySectionContactTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.privacySectionContactBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
