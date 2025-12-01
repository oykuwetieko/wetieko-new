import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/screens/02_onboarding_screen/05_location_permission_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class GenderSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const GenderSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  late String selectedGender;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedGender = AppLocalizations.of(context)!.female;
  }

  List<String> genders(BuildContext context) => [
        AppLocalizations.of(context)!.female,
        AppLocalizations.of(context)!.male,
        AppLocalizations.of(context)!.preferNotToSay,
      ];

  void _handleNext() {
    context.read<UserStateNotifier>().setGender(selectedGender);

    if (widget.fromProfileEdit) {
      Navigator.pop(context); // modal kapat
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationPermissionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final genderOptions = genders(context);

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
              currentStep: 1,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: _handleNext,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(
              title: localizations.genderQuestion,
              subtitle: localizations.genderHelpText,
              align: TextAlign.left,
            ),
            const SizedBox(height: 16),
            for (final gender in genderOptions)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: selectedGender == gender
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textFieldBorder),
                      boxShadow: selectedGender == gender
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
                          gender,
                          style: AppTextStyles.buttonText.copyWith(
                            color: selectedGender == gender
                                ? AppColors.onboardingButtonText
                                : AppColors.onboardingTitle,
                          ),
                        ),
                        if (selectedGender == gender)
                          const Icon(Icons.check_circle,
                              color: AppColors.onboardingButtonText),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
