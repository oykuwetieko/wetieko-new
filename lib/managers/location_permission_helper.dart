import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionHelper {
  static const MethodChannel _channel =
      MethodChannel('Wetieko/location_permission');

  static Future<bool> getActualLocationStatus() async {
    if (!Platform.isIOS) {
      return await Permission.location.isGranted;
    }

    try {
      final result = await _channel.invokeMethod<String>('getLocationStatus');
      return result == 'always' || result == 'whenInUse';
    } catch (e) {
     
      return await Permission.location.isGranted;
    }
  }
}
