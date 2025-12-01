import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPermissionHelper {
  static const MethodChannel _channel =
      MethodChannel('Wetieko/notification_permission');

  static Future<bool> getActualNotificationStatus() async {
    try {
    
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
    
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        return true;
      }

      // 🔹 2. Eğer hala değilse platforma göre kontrol et
      if (!Platform.isIOS) {
        return await Permission.notification.isGranted;
      }

      // 🔹 3. iOS için native method channel üzerinden de dene
      final result =
          await _channel.invokeMethod<String>('getNotificationStatus');
    

      return result == 'authorized' || result == 'provisional';
    } catch (e) {
    
      return await Permission.notification.isGranted;
    }
  }
}
