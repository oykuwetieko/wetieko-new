import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/states/user_state.dart';

class ProfileViewAttributes extends StatelessWidget {
  final UserState? userState;
  final User? externalUser;

  const ProfileViewAttributes({
    super.key,
    this.userState,
    this.externalUser,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final usagePurposes = externalUser?.usagePreference ?? userState?.usagePurposes ?? [];
    final sectors = externalUser?.industry ?? userState?.sectors ?? [];
    final positions = externalUser?.careerPosition ?? userState?.positions ?? [];
    final skills = externalUser?.skills ?? userState?.skills ?? [];
    final workEnvironments = externalUser?.workEnvironment ?? userState?.workEnvironments ?? [];

    final sections = [
      _AttributeSection(loc.usagePurposes, usagePurposes, Icons.flag),
      _AttributeSection(loc.sectors, sectors, Icons.apartment),
      _AttributeSection(loc.positions, positions, Icons.badge),
      _AttributeSection(
        loc.skills,
        skills.isNotEmpty ? skills : ['Flutter', 'Figma', 'Firebase'],
        Icons.handyman,
      ),
      _AttributeSection(
        loc.workingEnvironment,
        workEnvironments.isNotEmpty
            ? workEnvironments
            : ['Remote', 'Ofis', 'Hibrit'],
        Icons.home_work,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections
            .where((s) => s.values.isNotEmpty)
            .map(_buildAttributeSection)
            .toList(),
      ),
    );
  }

  Widget _buildAttributeSection(_AttributeSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Başlık + ikon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(section.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                section.label,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingTitle,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 28,
            margin: const EdgeInsets.only(left: 26),
            color: AppColors.primary.withOpacity(0.8),
          ),
          const SizedBox(height: 16),

          /// Etiketler
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: section.values.map((value) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.tagBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.textFieldBorder.withOpacity(0.6),
                  ),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tagText,
                    letterSpacing: 0.1,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AttributeSection {
  final String label;
  final List<String> values;
  final IconData icon;

  _AttributeSection(this.label, this.values, this.icon);
}
