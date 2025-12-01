import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';

class WorkplaceSearchList extends StatelessWidget {
  final List<Place> places;
  final String searchQuery;
  final void Function(Place)? onPlaceTap;

  const WorkplaceSearchList({
    super.key,
    required this.places,
    this.searchQuery = '',
    this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = places.where((place) {
      final name = place.name?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: filteredPlaces.length,
      separatorBuilder: (_, __) => Divider(
        color: AppColors.neutralGrey.withOpacity(0.25),
        height: 16,
      ),
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        return InkWell(
          onTap: () {
            if (onPlaceTap != null) {
              onPlaceTap!(place); // ✅ Sadece dışarıdan gelen fonksiyon çalıştırılıyor
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiscoverWorkplaceDetailScreen(place: place),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bottomNavBackground.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.place_outlined,
                    size: 20,
                    color: AppColors.bottomNavBackground,
                  ),
                ),
              ),
              title: Text(
                place.name ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDark,
                  height: 1.1,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  place.formattedAddress ?? '',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.neutralText,
                    height: 1.2,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.categoryInactiveText,
              ),
            ),
          ),
        );
      },
    );
  }
}
