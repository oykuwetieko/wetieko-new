import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/data/constants/creation_option_type.dart';


class CreateOptionTile extends StatelessWidget {
  final VoidCallback onTap;
  final CreateOptionType type;
  final AppLocalizations localizations;

  const CreateOptionTile({
    super.key,
    required this.onTap,
    required this.type,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late String title;
    late String subtitle;

    switch (type) {
      case CreateOptionType.collaborate:
        icon = Icons.people_alt;
        title = localizations.createCollaborate;
        subtitle = localizations.findNewCoworkers;
        break;
      case CreateOptionType.cowork:
        icon = Icons.groups;
        title = localizations.cowork;
        subtitle = localizations.collaborateText;
        break;
      case CreateOptionType.activity:
        icon = Icons.diversity_3;
        title = localizations.activities;
        subtitle = localizations.createEvent;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neutralGrey,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sol renkli şerit
            Container(
              width: 6,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // İçerik kısmı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: AppTextStyles.onboardingTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: AppTextStyles.onboardingSubtitle.copyWith(
                        fontSize: 13,
                        color: AppColors.neutralText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
