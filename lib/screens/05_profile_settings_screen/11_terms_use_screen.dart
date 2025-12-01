import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class TermsUseScreen extends StatelessWidget {
  const TermsUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.termsOfUse,
        showStepBar: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.termsSectionIntroTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionIntroBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionEligibilityTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionEligibilityBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionAccountTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionAccountBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionUsageTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionUsageBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionIntellectualPropertyTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionIntellectualPropertyBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionUserConductTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionUserConductBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionThirdPartyTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionThirdPartyBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionTerminationTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionTerminationBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionChangesTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionChangesBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionLiabilityTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionLiabilityBody,
                style: AppTextStyles.onboardingSubtitle,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 20),
              Text(
                loc.termsSectionContactTitle,
                style: AppTextStyles.onboardingTitle,
              ),
              const SizedBox(height: 8),
              Text(
                loc.termsSectionContactBody,
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
