import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_main/map_header.dart';
import 'package:Wetieko/widgets/discover/discover_main/map_workplace_sheet.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';
import 'package:Wetieko/widgets/discover/discover_main/custom_place_popup.dart';
import 'package:Wetieko/states/place_state_notifier.dart';

class WorkplaceMapScreen extends StatefulWidget {
  final String selectedCategory;

  const WorkplaceMapScreen({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<WorkplaceMapScreen> createState() => _WorkplaceMapScreenState();
}

class _WorkplaceMapScreenState extends State<WorkplaceMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Place? _selectedPlace;
  Offset? _popupPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final placeState = context.watch<PlaceStateNotifier>();
    _setMarkers(placeState.places);
  }

  void _setMarkers(List<Place> places) {
    final markers = places.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.lat, place.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () async {
          if (_mapController != null) {
            final screenPoint = await _mapController!.getScreenCoordinate(
              LatLng(place.lat, place.lng),
            );
            setState(() {
              _selectedPlace = place;
              _popupPosition = Offset(
                screenPoint.x.toDouble(),
                screenPoint.y.toDouble(),
              );
            });
          }
        },
      );
    }).toSet();

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
    });
  }

  void _onCameraMove(CameraPosition position) {
    if (_selectedPlace != null && _mapController != null) {
      _mapController!
          .getScreenCoordinate(LatLng(_selectedPlace!.lat, _selectedPlace!.lng))
          .then((screenPoint) {
        setState(() {
          _popupPosition = Offset(
            screenPoint.x.toDouble(),
            screenPoint.y.toDouble(),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeState = context.watch<PlaceStateNotifier>();
    final workplaces = placeState.places;

    final initialPlace = workplaces.isNotEmpty
        ? workplaces.first
        : Place.empty();

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: Stack(
        children: [
          // Google Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(initialPlace.lat, initialPlace.lng),
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              onCameraMove: _onCameraMove,
              onTap: (_) {
                setState(() {
                  _selectedPlace = null;
                  _popupPosition = null;
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
            ),
          ),

          // Custom InfoWindow
          if (_selectedPlace != null && _popupPosition != null)
            Positioned(
              left: _popupPosition!.dx - 100,
              top: _popupPosition!.dy - 130,
              child: CustomPlacePopup(
                place: _selectedPlace!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiscoverWorkplaceDetailScreen(
                        place: _selectedPlace!,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapHeader(
              selectedCategory: widget.selectedCategory,
              places: workplaces,
              onListPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Bottom sheet
          MapWorkplaceSheet(
            workplaces: workplaces,
            mapController: _mapController,
          ),
        ],
      ),
    );
  }
}
