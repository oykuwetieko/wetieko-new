import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/screens/02_onboarding_screen/07_sector_selection_screen.dart';
import 'package:Wetieko/data/constants/usage_purpose_list.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class UsageSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const UsageSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<UsageSelectionScreen> createState() => _UsageSelectionScreenState();
}

class _UsageSelectionScreenState extends State<UsageSelectionScreen> {
  late List<String> usageOptions;
  final Set<String> selectedOptions = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usageOptions = usagePurposeList(context);
    if (selectedOptions.isEmpty && usageOptions.isNotEmpty) {
      selectedOptions.add(usageOptions[0]);
    }
  }

  void _toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        if (selectedOptions.length > 1) {
          selectedOptions.remove(option);
        }
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void _handleNext() {
    context.read<UserStateNotifier>().setUsagePurposes(selectedOptions.toList());

    if (widget.fromProfileEdit) {
      Navigator.pop(context); // 🔙 Modal olarak açıldıysa kapat
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SectorSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              currentStep: 3,
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
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                      title: localizations.howDoYouWantToUseTieWork,
                      subtitle: localizations.usagePurposeDescription,
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    for (final option in usageOptions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _toggleOption(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: selectedOptions.contains(option)
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.textFieldBorder),
                              boxShadow: selectedOptions.contains(option)
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
                                Flexible(
                                  child: Text(
                                    option,
                                    style: AppTextStyles.buttonText.copyWith(
                                      color: selectedOptions.contains(option)
                                          ? AppColors.onboardingButtonText
                                          : AppColors.onboardingTitle,
                                    ),
                                  ),
                                ),
                                if (selectedOptions.contains(option))
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
            ),
          ),
        ],
      ),
    );
  }
}
