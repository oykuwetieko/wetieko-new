import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/screens/06_notification_screen/02_notification_detail_list_screen.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/main.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/screens/03_discover_screen/04_discover_activity_detail_screen.dart';
import 'package:Wetieko/screens/03_discover_screen/02_discover_together_detail_screen.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();


  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {

  

    await NotificationManager().showLocalNotification(message);
  }

 
  Future<void> initialize({bool requestPermission = false}) async {
   

    if (requestPermission) {
      await _requestPermission();
    }

    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    _handleTerminatedAppLaunch();
  }


  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

  
  }


  Future<void> _initLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
       
      },
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }


  void _onForegroundMessage(RemoteMessage message) async {
 

    final data = message.data;

    if (data['totalUnread'] != null) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        final notifier = ctx.read<AppNotificationStateNotifier>();
        notifier.unreadSummary['totalUnread'] =
            int.tryParse(data['totalUnread'].toString()) ?? 0;
        notifier.notifyListeners();
      }
    }

   
  }


  void _onMessageOpened(RemoteMessage message) async {
 
    await _handleNotificationTap(
      message.data['type'],
      message.data['id'],
      message.data['sender'],
      message.data['eventId'],
    );
  }

 
  Future<void> _handleTerminatedAppLaunch() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
     
      await _handleNotificationTap(
        message.data['type'],
        message.data['id'],
        message.data['sender'],
        message.data['eventId'],
      );
    } else {
     
    }
  }

 
  Future<void> showLocalNotification(RemoteMessage message) async {
   

    final title =
        message.notification?.title ?? message.data['title'] ?? 'Yeni Bildirim';

    final body =
        message.notification?.body ?? message.data['body'] ?? '';

    final androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = const DarwinNotificationDetails();

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: message.data.toString(),
    );

 
  }


  Future<void> _handleNotificationTap(
    String? type,
    String? notificationId,
    String? senderJsonStr,
    String? eventId,
  ) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    print("📍 TAP → type=$type id=$notificationId");

    try {
      if (notificationId != null) {
        await ctx.read<AppNotificationStateNotifier>().markAsRead(notificationId);
        print("✅ Bildirim okundu: $notificationId");
      }
    } catch (_) {}

    if (type == 'profile_view') {
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (_) => const NotificationDetailListScreen(type: 'profile_view'),
      ));
    } else if (type == 'follow_request') {
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (_) => const NotificationDetailListScreen(type: 'new_follower'),
      ));
    } else if (type == 'follow_accepted' && senderJsonStr != null) {
      final senderMap = jsonDecode(senderJsonStr);
      final sender = User.fromJson(Map<String, dynamic>.from(senderMap));
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (_) => ProfileViewScreen(externalUser: sender),
      ));
    } else if (type == 'message_received') {
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper(initialIndex: 1)),
        (route) => false,
      );
    } else if (type == 'event_updated' && eventId != null) {
      try {
        final event =
            await ctx.read<EventStateNotifier>().fetchEventDetail(eventId);
        final screen = event.type == EventType.BIRLIKTE_CALIS
            ? DiscoverTogetherDetailScreen(event: event)
            : DiscoverActivityDetailScreen(event: event);

        navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => screen));
      } catch (e) {
     
      }
    } else if (type == 'event_deleted') {
      
    }
  }
}
