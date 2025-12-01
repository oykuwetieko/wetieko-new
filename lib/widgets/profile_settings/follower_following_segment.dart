import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class FollowerFollowingSegment extends StatefulWidget {
  final void Function(int selectedIndex)? onTabChanged;
  final int initialSelection;

  const FollowerFollowingSegment({
    super.key,
    this.onTabChanged,
    this.initialSelection = 0,
  });

  @override
  State<FollowerFollowingSegment> createState() =>
      _FollowerFollowingSegmentState();
}

class _FollowerFollowingSegmentState extends State<FollowerFollowingSegment> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelection;
  }

  void _onTabTap(int index) {
    setState(() => selectedIndex = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.neutralLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.categoryInactiveText.withOpacity(0.4), // ✳️ border rengi değişti
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            _buildTab(
              icon: Icons.people_alt_rounded,
              label: loc.followers,
              index: 0,
            ),
            _buildTab(
              icon: Icons.person_add_alt_1_rounded,
              label: loc.following,
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.neutralText, // ✳️ seçilmemiş renk değişti
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.neutralText, // ✳️ seçilmemiş renk değişti
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
