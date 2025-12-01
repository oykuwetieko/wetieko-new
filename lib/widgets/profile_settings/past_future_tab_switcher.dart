import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class TabSwitcher extends StatefulWidget {
  final void Function(int selectedIndex)? onTabChanged;

  const TabSwitcher({super.key, this.onTabChanged});

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  int selectedIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Seçilen sekme dışarıya bildirilir
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      color: AppColors.onboardingBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTab(title: loc.upcoming, index: 0),
              const SizedBox(width: 20),
              _buildTab(title: loc.past, index: 1),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1.5,
            width: double.infinity,
            color: AppColors.textFieldBorder.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required int index}) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.onboardingTitle
                  : AppColors.categoryInactiveText,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? 40 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
