import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/states/user_state_notifier.dart';

class SearchHeader extends StatelessWidget {
  final bool showUsers;
  final ValueChanged<bool>? onToggle;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchHeader({
    super.key,
    required this.showUsers,
    this.onToggle,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: hintText,
                icon: Icons.search,
                textColor: AppColors.neutralLight,
                hintTextColor: AppColors.neutralLight,
                iconColor: AppColors.neutralLight,
                borderColor: AppColors.neutralGrey,
                onChanged: onChanged,
              ),
              if (onToggle != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildButton(
                      label: loc.places,
                      icon: Icons.place,
                      selected: !showUsers,
                      onTap: () => onToggle!(false),
                    ),
                    const SizedBox(width: 8),
                    _buildButton(
                      label: loc.users,
                      icon: Icons.person,
                      selected: showUsers,
                      onTap: () {
                        debugPrint("👤 Kullanıcılar sekmesine geçildi.");
                        context.read<UserStateNotifier>().fetchAllUsers();
                        onToggle!(true);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 30,
      decoration: BoxDecoration(
        color: selected ? AppColors.neutralLight : Colors.transparent,
        border: selected ? null : Border.all(color: AppColors.neutralLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected
                  ? AppColors.bottomNavBackground
                  : AppColors.neutralLight,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.bottomNavBackground
                    : AppColors.neutralLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
