import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/data/constants/experience_level_list.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/screens/02_onboarding_screen/11_environment_selection_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class ExperienceSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const ExperienceSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<ExperienceSelectionScreen> createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> {
  late String selectedLevel = '';

  void _handleNext() {
    context.read<UserStateNotifier>().setExperienceLevel(selectedLevel);

    if (widget.fromProfileEdit) {
      Navigator.pop(context); // Modal kapat
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EnvironmentSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final levels = experienceLevelList(context);
    final localizations = AppLocalizations.of(context)!;

    if (selectedLevel.isEmpty && levels.isNotEmpty) {
      selectedLevel = levels.first;
    }

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: widget.fromProfileEdit
          ? AppBar(
              backgroundColor: AppColors.onboardingBackground,
              elevation: 0,
              automaticallyImplyLeading: false,
            )
          : const CustomAppBar(
              totalSteps: 10,
              currentStep: 7,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(onPressed: _handleNext),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20), // Yukarıdan boşluk eklendi
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                      title: localizations.whichExperienceLevel,
                      subtitle: localizations.experienceInfo,
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    for (final level in levels)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLevel = level;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: selectedLevel == level
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.textFieldBorder,
                              ),
                              boxShadow: selectedLevel == level
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  level,
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: selectedLevel == level
                                        ? AppColors.onboardingButtonText
                                        : AppColors.onboardingTitle,
                                  ),
                                ),
                                if (selectedLevel == level)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.onboardingButtonText,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
