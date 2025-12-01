import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/create_option/create_option_tile.dart';
import 'package:Wetieko/widgets/create_option/create_option_step_bar.dart';
import 'package:Wetieko/screens/04_create_options_screen/02_option_activity_screen.dart';
import 'package:Wetieko/data/constants/creation_option_type.dart';


class MainCreateOptionsScreen extends StatelessWidget {
  const MainCreateOptionsScreen({super.key});

  void navigateToActivity({
    required BuildContext context,
    required CreateOptionType type,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OptionActivityScreen(type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: localizations.whatDoYouWantToCreate,
        showStepBar: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CreateOptionStepBar(totalSteps: 2, currentStep: 1),
            const SizedBox(height: 24),

            // 🔹 Birlikte Çalış
            CreateOptionTile(
              type: CreateOptionType.collaborate,
              localizations: localizations,
              onTap: () => navigateToActivity(
                context: context,
                type: CreateOptionType.collaborate,
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Cowork
            CreateOptionTile(
              type: CreateOptionType.cowork,
              localizations: localizations,
              onTap: () => navigateToActivity(
                context: context,
                type: CreateOptionType.cowork,
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 Etkinlik
            CreateOptionTile(
              type: CreateOptionType.activity,
              localizations: localizations,
              onTap: () => navigateToActivity(
                context: context,
                type: CreateOptionType.activity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
