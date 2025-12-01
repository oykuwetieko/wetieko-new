import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class EventFeature {
  final String key;
  final IconData icon;

  const EventFeature({required this.key, required this.icon});
}

class EventFeaturesGrid extends StatefulWidget {
  final void Function(Set<String>)? onChanged;
  final Set<String>? initialSelectedFeatures; // ✅ yeni eklendi

  const EventFeaturesGrid({
    super.key,
    this.onChanged,
    this.initialSelectedFeatures,
  });

  @override
  State<EventFeaturesGrid> createState() => _EventFeaturesGridState();
}

class _EventFeaturesGridState extends State<EventFeaturesGrid> {
  static const List<EventFeature> _features = [
    EventFeature(key: 'hasSpeaker', icon: Icons.campaign),
    EventFeature(key: 'hasWorkshop', icon: Icons.build_circle),
    EventFeature(key: 'hasCertificate', icon: Icons.verified),
    EventFeature(key: 'isFree', icon: Icons.money_off_csred),
    EventFeature(key: 'hasTreat', icon: Icons.local_cafe),
    EventFeature(key: 'hasRaffle', icon: Icons.confirmation_number),
    EventFeature(key: 'hasGift', icon: Icons.volunteer_activism),
    EventFeature(key: 'isOutdoor', icon: Icons.nature_people),
    EventFeature(key: 'hasSeatTable', icon: Icons.table_restaurant),
    EventFeature(key: 'hasPhotoVideo', icon: Icons.camera_alt),
  ];

  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();

    // ✅ düzenleme modunda gelen mevcut seçimleri aktif et
    if (widget.initialSelectedFeatures != null) {
      for (int i = 0; i < _features.length; i++) {
        if (widget.initialSelectedFeatures!.contains(_features[i].key)) {
          _selectedIndices.add(i);
        }
      }
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });

    final selectedKeys = _selectedIndices.map((i) => _features[i].key).toSet();
    widget.onChanged?.call(selectedKeys);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final localizedTitles = {
      'hasSpeaker': loc.speaker,
      'hasWorkshop': loc.workshop,
      'hasCertificate': loc.certificate,
      'isFree': loc.free,
      'hasTreat': loc.catering,
      'hasRaffle': loc.raffle,
      'hasGift': loc.gift,
      'isOutdoor': loc.openSpace,
      'hasSeatTable': loc.seatAndTable,
      'hasPhotoVideo': loc.photoVideo,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            loc.eventFeatures,
            style: AppTextStyles.onboardingTitle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.neutralDark,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 4.5,
          ),
          itemCount: _features.length,
          itemBuilder: (context, index) {
            final feature = _features[index];
            final isSelected = _selectedIndices.contains(index);
            final title = localizedTitles[feature.key]!;

            return GestureDetector(
              onTap: () => _toggleSelection(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      feature.icon,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.onboardingTitle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
