import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkplaceSegmentSwitcher extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;
  final int commentCount; 

  const WorkplaceSegmentSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.commentCount, 
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final tabs = {
      'detail': local.detail,
      'comments': '${local.comments} ($commentCount)', 
    };

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: tabs.entries.map((entry) {
          final isSelected = selectedTab == entry.key;

          return GestureDetector(
            onTap: () => onTabSelected(entry.key),
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
                child: Text(entry.value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
