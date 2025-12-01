import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkplaceFeaturesSelector extends StatefulWidget {
  final void Function(Map<String, bool>) onFeaturesChanged;

  const WorkplaceFeaturesSelector({
    super.key,
    required this.onFeaturesChanged,
  });

  @override
  State<WorkplaceFeaturesSelector> createState() =>
      _WorkplaceFeaturesSelectorState();
}

class _WorkplaceFeaturesSelectorState
    extends State<WorkplaceFeaturesSelector> {
  late Map<String, bool> _features;
  late Map<String, IconData> _icons;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;

    _features = {
      loc.suitableForMeeting: false,
      loc.openAir: false,
      loc.petFriendly: false,
      loc.parking: false,
      loc.view: false,
    };

    _icons = {
      loc.suitableForMeeting: Icons.groups_2_outlined,
      loc.openAir: Icons.park_outlined,
      loc.petFriendly: Icons.pets_outlined,
      loc.parking: Icons.local_parking_outlined,
      loc.view: Icons.landscape_outlined,
    };
  }

  void _toggle(String key) {
    setState(() {
      _features[key] = !_features[key]!;
      print('📌 Özellik durumu güncellendi: $_features');
      widget.onFeaturesChanged(_features);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            loc.spaceFeatures,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDark,
            ),
          ),
        ),
        WorkplaceRateInfoCard(
          message: loc.eventFeaturesHint,
        ),
        ..._features.entries.map((entry) {
          final key = entry.key;
          final selected = entry.value;
          final icon = _icons[key]!;

          return GestureDetector(
            onTap: () => _toggle(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : AppColors.neutralGrey.withOpacity(0.3),
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: selected
                        ? AppColors.primary
                        : AppColors.neutralText,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected
                            ? AppColors.primary
                            : AppColors.neutralDark,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: selected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            key: ValueKey(true),
                            color: AppColors.primary,
                            size: 22,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            key: ValueKey(false),
                            color: AppColors.neutralGrey,
                            size: 22,
                          ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
