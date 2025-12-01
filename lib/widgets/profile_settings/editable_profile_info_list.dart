import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/profile_settings/user_profile_header.dart';

import 'package:Wetieko/screens/02_onboarding_screen/02_name_input_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/03_birthdate_input_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/04_gender_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/06_usage_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/07_sector_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/08_position_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/09_skill_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/10_experience_selection_screen.dart';
import 'package:Wetieko/screens/02_onboarding_screen/11_environment_selection_screen.dart';

import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/update_user_dto.dart';

import 'package:Wetieko/widgets/common/custom_alerts.dart';

class EditableProfileInfoList extends StatelessWidget {
  const EditableProfileInfoList({super.key});

  Widget buildItem({
    required IconData icon,
    required String question,
    required String answer,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.closeButtonBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.closeButtonIcon),
      ),
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralDark,
        ),
      ),
      subtitle: Text(
        answer,
        style: const TextStyle(fontSize: 13, color: AppColors.neutralText),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.categoryInactiveText,
      ),
    );
  }

  Widget buildDivider() => Divider(
        height: 0,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: AppColors.neutralGrey.withOpacity(0.4),
      );

  void showPopup(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// 🔥 Burada artık DateTime alıyoruz, String değil
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = context.watch<UserStateNotifier>().state;
    final userNotifier = context.read<UserStateNotifier>();

    final items = <Widget>[
      buildItem(
        icon: Icons.edit,
        question: loc.editName,
        answer: state.fullName ?? '-',
        onTap: () => showPopup(context, const NameInputScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.cake,
        question: loc.editBirthday,
        answer: state.birthDate != null ? _formatDate(state.birthDate!) : '-',
        onTap: () => showPopup(context, const BirthdateInputScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.wc,
        question: loc.editGender,
        answer: state.gender ?? '-',
        onTap: () => showPopup(context, const GenderSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.lightbulb_outline,
        question: loc.editUsage,
        answer: state.usagePurposes.isNotEmpty ? state.usagePurposes.join(', ') : '-',
        onTap: () => showPopup(context, const UsageSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.business_center_outlined,
        question: loc.editSector,
        answer: state.sectors.isNotEmpty ? state.sectors.join(', ') : '-',
        onTap: () => showPopup(context, const SectorSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.assignment_ind_outlined,
        question: loc.editCareerPosition,
        answer: state.positions.isNotEmpty ? state.positions.join(', ') : '-',
        onTap: () => showPopup(context, const PositionSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.leaderboard_outlined,
        question: loc.editCareerLevel,
        answer: state.experienceLevel ?? '-',
        onTap: () => showPopup(context, const ExperienceSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.volume_off_outlined,
        question: loc.editWorkEnvironment,
        answer: state.workEnvironments.isNotEmpty ? state.workEnvironments.join(', ') : '-',
        onTap: () => showPopup(context, const EnvironmentSelectionScreen(fromProfileEdit: true)),
      ),
      buildItem(
        icon: Icons.code,
        question: loc.editSkills,
        answer: state.skills.isNotEmpty ? state.skills.join(', ') : '-',
        onTap: () => showPopup(context, const SkillSelectionScreen(fromProfileEdit: true)),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: UserProfileHeader(
            showLabels: true,
            showEditButton: false,
            avatarClickable: true,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          items.length * 2 - 1,
          (index) => index.isEven
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: items[index ~/ 2],
                )
              : buildDivider(),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomButton(
            text: loc.saveChanges,
            icon: Icons.task_alt,
            onPressed: () async {
             final dto = UpdateUserDto(
  name: state.fullName,
  birthDate: state.birthDate,
  gender: state.gender,
  location: state.city,
  usagePreference: state.usagePurposes,
  industry: state.sectors,
  careerPosition: state.positions,
  careerStage: state.experienceLevel,
  workEnvironment: state.workEnvironments,
  skills: state.skills,
  profileImage: state.profileImage ?? "",   // 🔥 BOŞ STRING GÖNDER
  language: state.language ?? "tr",          // 🔥 DEFAULT DİL EKLE
);


              try {
                final updatedUser = await userNotifier.userRepo.updateMe(dto);
                userNotifier.setUser(updatedUser);

                CustomAlert.show(
                  context,
                  title: loc.settingsUpdated,
                  description: loc.settingsSuccessMessage,
                  icon: Icons.check_circle_rounded,
                  confirmText: loc.ok,
                  onConfirm: () {},
                );
              } catch (e) {}
            },
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
