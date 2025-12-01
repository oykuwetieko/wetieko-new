import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/widgets/discover/discover_card/workplace_card.dart';
import 'package:Wetieko/widgets/common/modal_drag_handle.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';

class MapWorkplaceSheet extends StatelessWidget {
  final List<Place> workplaces;
  final GoogleMapController? mapController;

  const MapWorkplaceSheet({
    super.key,
    required this.workplaces,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.2,
      maxChildSize: 0.35,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.categoryInactiveBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ModalDragHandle(),
              Text(
                loc.venueList,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onboardingTitle,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: workplaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    final place = workplaces[index];
                    return WorkplaceCard(
                      place: place,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DiscoverWorkplaceDetailScreen(place: place),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
