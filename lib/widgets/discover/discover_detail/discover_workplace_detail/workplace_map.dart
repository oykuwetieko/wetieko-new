import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';

class WorkplaceMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const WorkplaceMap({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final LatLng coord = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: AppleMap(
          initialCameraPosition: CameraPosition(
            target: coord,
            zoom: 14,
          ),
          annotations: {
            Annotation(
              annotationId: AnnotationId('location'),
              position: coord,
            ),
          },
        ),
      ),
    );
  }
}
