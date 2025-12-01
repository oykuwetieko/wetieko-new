import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ActivitySegmentSwitcher extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const ActivitySegmentSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final tabs = [
      loc.eventDetail, // "Etkinlik Detay"
      loc.placeDetail, // "Mekan Detay"
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;

          return GestureDetector(
            onTap: () => onTabSelected(tab),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.neutralDark.withOpacity(0.6),
                ),
                child: Text(tab),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
