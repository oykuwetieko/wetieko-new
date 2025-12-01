// cowork_event_match_segment.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class CoworkEventMatchSegment extends StatefulWidget {
  final void Function(String label)? onSelectionChanged;
  final String? selectedLabel;

  const CoworkEventMatchSegment({
    super.key,
    this.onSelectionChanged,
    this.selectedLabel,
  });

  @override
  State<CoworkEventMatchSegment> createState() => _CoworkEventMatchSegmentState();
}

class _CoworkEventMatchSegmentState extends State<CoworkEventMatchSegment> {
  late String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedLabel;
  }

  void _onTap(String label) {
    setState(() {
      selected = label;
    });
    widget.onSelectionChanged?.call(label);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final items = [
      {
        'label': loc.cowork,
        'icon': Icons.laptop_mac,
      },
      {
        'label': loc.activities,
        'icon': Icons.event,
      },
      {
        'label': loc.match,
        'icon': Icons.person_search_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.neutralLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.categoryInactiveText.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          children: items.map((item) {
            final String label = item['label'] as String;
            final IconData icon = item['icon'] as IconData;
            final bool isSelected = selected == label;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onTap(label),
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
                            : AppColors.neutralText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.neutralText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
