import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class DiscoverCategorySelector extends StatefulWidget {
  final void Function(String)? onCategorySelected;
  final String selectedCategoryKey;

  const DiscoverCategorySelector({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategoryKey,
  });

  @override
  State<DiscoverCategorySelector> createState() =>
      _DiscoverCategorySelectorState();
}

class _DiscoverCategorySelectorState extends State<DiscoverCategorySelector> {
  late String selectedCategoryKey;

  @override
  void initState() {
    super.initState();
    selectedCategoryKey = widget.selectedCategoryKey;
    print('[DiscoverCategorySelector] initState: $selectedCategoryKey');
  }

  @override
  void didUpdateWidget(covariant DiscoverCategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategoryKey != widget.selectedCategoryKey) {
      setState(() {
        selectedCategoryKey = widget.selectedCategoryKey;
        print('[DiscoverCategorySelector] didUpdateWidget: $selectedCategoryKey');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final categoryKeys = ['workplaces', 'collaborateNow', 'cowork', 'activities'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.discoverCategorySelector,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onboardingTitle,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryKeys.length,
            itemBuilder: (context, index) {
              final key = categoryKeys[index];
              final label = _mapCategoryKeyToLocalized(key, locale);
              final isSelected = selectedCategoryKey == key;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategoryKey = key;
                  });

                  print('[DiscoverCategorySelector] Tıklanan kategori key: $key');
                  widget.onCategorySelected?.call(key);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.categoryActive.withOpacity(0.12)
                        : const Color(0xFFECEFF4),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: const Color(0xFFCBD5E1),
                            width: 1,
                          ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(key),
                        size: 13,
                        color: isSelected
                            ? AppColors.categoryActive
                            : AppColors.onboardingTitle.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.categoryActive
                              : AppColors.onboardingTitle.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _mapCategoryKeyToLocalized(String key, AppLocalizations loc) {
    switch (key) {
      case 'cowork':
        return loc.cowork;
      case 'activities':
        return loc.activities;
      case 'collaborateNow':
        return loc.collaborateNow;
      case 'workplaces':
      default:
        return loc.workplaces;
    }
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'cowork':
        return Icons.hub;
      case 'activities':
        return Icons.event;
      case 'collaborateNow':
        return Icons.groups;
      case 'workplaces':
      default:
        return Icons.apartment;
    }
  }
}
