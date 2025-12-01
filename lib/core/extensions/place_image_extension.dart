import 'package:Wetieko/data/constants/env.dart';
import 'package:Wetieko/models/place_model.dart';

extension PlaceImageExtension on Place {
  String? get imageUrl {
    if (photoReferences.isEmpty) return null;
    return _buildPhotoUrl(photoReferences.first);
  }

  List<String> get allImageUrls {
    return photoReferences.map(_buildPhotoUrl).toList();
  }

  String _buildPhotoUrl(String reference) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
           '?maxwidth=800'
           '&photoreference=$reference'
           '&key=${Env.googleApiKey}';
  }
}
