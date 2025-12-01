import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class LanguageSettingsList extends StatelessWidget {
  final String selectedLanguageCode;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSettingsList({
    super.key,
    required this.selectedLanguageCode,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildLanguageTile(
          context,
          languageCode: 'tr',
          languageLabel: loc.turkishLanguage,
          flagEmoji: '🇹🇷',
        ),
        _buildLanguageTile(
          context,
          languageCode: 'en',
          languageLabel: loc.englishLanguage,
          flagEmoji: '🇺🇸',
        ),
      ],
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String languageCode,
    required String languageLabel,
    required String flagEmoji,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: RadioListTile<String>(
          value: languageCode,
          groupValue: selectedLanguageCode,
          onChanged: (value) {
            if (value != null) {
              onLanguageChanged(value);
            }
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            '$flagEmoji  $languageLabel',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDark,
            ),
          ),
          activeColor: AppColors.primary,
          tileColor: Colors.white,
          selectedTileColor: Colors.white,
        ),
      ),
    );
  }
}
