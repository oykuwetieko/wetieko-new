import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/profile_settings/language_settings_list.dart';
import 'package:Wetieko/managers/language_manager.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguageCode = 'tr';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Provider.of<LanguageManager>(context).locale;
    _selectedLanguageCode = currentLocale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.appLanguage,
        showStepBar: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: LanguageSettingsList(
              selectedLanguageCode: _selectedLanguageCode,
              onLanguageChanged: (code) {
                setState(() {
                  _selectedLanguageCode = code;
                });
              },
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 45,
            child: CustomButton(
              text: loc.saveChanges,
              icon: Icons.task_alt,
              onPressed: () async {
                final success = await Provider.of<LanguageManager>(
                  context,
                  listen: false,
                ).setLocale(_selectedLanguageCode, context: context);

                // ✅ Başarılı olursa mesaj göster
                if (success) {
                  CustomAlert.show(
                    context,
                    title: loc.settingsUpdated,
                    description: loc.settingsSuccessMessage,
                    icon: Icons.check_circle_rounded,
                    confirmText: loc.ok,
                    onConfirm: () {},
                  );
                }
              },
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
