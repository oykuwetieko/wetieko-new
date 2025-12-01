import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/data/constants/environment_list.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/screens/02_onboarding_screen/01_login_screen.dart'; // ✅ LoginScreen import

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class EnvironmentSelectionScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const EnvironmentSelectionScreen({super.key, this.fromProfileEdit = false});

  @override
  State<EnvironmentSelectionScreen> createState() =>
      _EnvironmentSelectionScreenState();
}

class _EnvironmentSelectionScreenState
    extends State<EnvironmentSelectionScreen> {
  late Set<String> selectedEnvironments = {};
  late List<String> environments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    environments = environmentList(context);

    if (selectedEnvironments.isEmpty && environments.isNotEmpty) {
      selectedEnvironments = {environments.first};
    }
  }

  void _toggleEnvironment(String env, BuildContext context) {
    final doesntMatter = AppLocalizations.of(context)!.doesNotMatter;

    setState(() {
      if (env == doesntMatter) {
        selectedEnvironments
          ..clear()
          ..add(doesntMatter);
        return;
      }

      if (selectedEnvironments.contains(doesntMatter)) {
        selectedEnvironments.remove(doesntMatter);
      }

      if (selectedEnvironments.contains(env)) {
        if (selectedEnvironments.length > 1) {
          selectedEnvironments.remove(env);
        }
      } else {
        selectedEnvironments.add(env);
      }
    });
  }

  void _handleNext() {
    context
        .read<UserStateNotifier>()
        .setWorkEnvironments(selectedEnvironments.toList());

    if (widget.fromProfileEdit) {
      Navigator.pop(context); // Modal kapat
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // ✅ Artık LoginScreen
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
              currentStep: 8,
              showStepBar: true,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: selectedEnvironments.isNotEmpty ? _handleNext : null,
        ),
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
                      title: localizations.whichEnvironment,
                      subtitle: localizations.environmentInfo,
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 24),
                    for (final env in environments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _toggleEnvironment(env, context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: selectedEnvironments.contains(env)
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.textFieldBorder,
                              ),
                              boxShadow: selectedEnvironments.contains(env)
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    env,
                                    style: AppTextStyles.buttonText.copyWith(
                                      color: selectedEnvironments.contains(env)
                                          ? AppColors.onboardingButtonText
                                          : AppColors.onboardingTitle,
                                    ),
                                  ),
                                ),
                                if (selectedEnvironments.contains(env))
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
