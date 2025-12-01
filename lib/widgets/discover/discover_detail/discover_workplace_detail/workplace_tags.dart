import 'package:flutter/material.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';

class WorkplaceTags extends StatelessWidget {
  final List<PlaceTag> tags;
  final Place place;

  const WorkplaceTags({
    super.key,
    required this.tags,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final workingConditions = tags
        .where((tag) => tag.category == PlaceTagCategory.workingConditions)
        .toList();
    final spaceFeatures = tags
        .where((tag) => tag.category == PlaceTagCategory.spaceFeatures)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (workingConditions.isNotEmpty)
          _buildScrollableTagSection(
            icon: Icons.work_outline,
            title: "Çalışma Koşulları",
            tagList: workingConditions,
          ),
        const SizedBox(height: 20),
        _buildScrollableTagSection(
          icon: Icons.space_dashboard_outlined,
          title: "Mekan Özellikleri",
          tagList: spaceFeatures,
        ),
        _buildFeatureTagRow(), 
      ],
    );
  }

  Widget _buildScrollableTagSection({
    required IconData icon,
    required String title,
    required List<PlaceTag> tagList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.onboardingTitle),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onboardingTitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (tagList.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: tagList.map((tag) => _buildTagChip(tag)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTagChip(PlaceTag tag) {
    final denominator = 5;
    final valueStr = '${tag.value.toStringAsFixed(1)} / $denominator';

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tagBackground,
        border: Border.all(color: AppColors.neutralGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(tag.icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            tag.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDark,
            ),
          ),
          const SizedBox(width: 6),
          Container(width: 1, height: 14, color: AppColors.neutralGrey),
          const SizedBox(width: 6),
          Text(
            valueStr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTagRow() {
    final features = [
      _Feature("Toplantı Alanı", Icons.meeting_room_outlined, place.hasMeetingArea ?? false),
      _Feature("Açık Hava", Icons.park_outlined, place.hasOutdoorArea ?? false),
      _Feature("Evcil Hayvan Dostu", Icons.pets_outlined, place.isPetFriendly ?? false),
      _Feature("Otopark", Icons.local_parking_outlined, place.hasParking ?? false),
      _Feature("Manzara", Icons.landscape_outlined, place.hasView ?? false),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: features.map((f) {
          final baseColor = AppColors.primary;
          final fadedColor = baseColor.withOpacity(0.4);

          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tagBackground,
              border: Border.all(color: AppColors.neutralGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  f.icon,
                  size: 16,
                  color: f.available ? baseColor : fadedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  f.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: f.available ? AppColors.neutralDark : fadedColor,
                    decoration: f.available
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Feature {
  final String label;
  final IconData icon;
  final bool available;

  _Feature(this.label, this.icon, this.available);
}
