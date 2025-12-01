import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationData {
  final String city;
  final String district;
  final double latitude;
  final double longitude;

  LocationData({
    required this.city,
    required this.district,
    required this.latitude,
    required this.longitude,
  });
}

class LocationManager {
  /// Konum ve adres bilgisini döndüren fonksiyon
  static Future<LocationData?> getLocation() async {
    // Konum izni kontrol et
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied ||
          newPermission == LocationPermission.deniedForever) {
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return LocationData(
        city: place.administrativeArea ?? '',
        district: place.subAdministrativeArea ?? place.locality ?? '',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } else {
      return null;
    }
  }
}
