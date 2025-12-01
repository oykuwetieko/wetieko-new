import 'package:flutter/material.dart';
import 'package:Wetieko/core/services/message_socket_service.dart';
import 'package:Wetieko/core/services/notification_socket_service.dart';
import 'package:Wetieko/data/repositories/app_notification_repository.dart';
import 'package:Wetieko/data/repositories/message_repository.dart';
import 'package:Wetieko/models/app_notification.dart';

class AppNotificationStateNotifier extends ChangeNotifier {
  final AppNotificationRepository repo;
  final MessageRepository messageRepo;

  // 🔌 Socket servisleri
  final MessageSocketService _messageSocket = MessageSocketService();
  final NotificationSocketService _notifSocket = NotificationSocketService();

  /// 👇 dışarıdan erişilebilsin diye getter
  MessageSocketService get socketService => _messageSocket;

  AppNotificationStateNotifier(this.repo, this.messageRepo) {
    // 🧩 Mesaj unread sayısı dinleme
    _messageSocket.unreadCountUpdatedStream.listen((count) {
      _unreadMessageCount = count;
     
      notifyListeners();
    });

    // 🧩 Bildirim unread sayısı dinleme
    _notifSocket.unreadCountStream.listen((count) {
      _unreadSummary['totalUnread'] = count;
     
      notifyListeners();
    });
  }

  // --------------------------------------------------------------------
  // STATE
  // --------------------------------------------------------------------
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  bool _loading = false;
  bool get loading => _loading;

  Map<String, dynamic> _unreadSummary = {};
  Map<String, dynamic> get unreadSummary => _unreadSummary;

  int _unreadMessageCount = 0;
  int get unreadMessageCount => _unreadMessageCount;

  // --------------------------------------------------------------------
  // 🔌 SOCKET Kontrolleri — YENİ HALİ (3 parametre)
  // --------------------------------------------------------------------
  void connectSockets(String baseUrl, String userId) {
  debugPrint("🔌 [Notifier] Socket bağlantıları başlatılıyor...");
  _messageSocket.connect(baseUrl, userId);
  _notifSocket.connect(baseUrl, userId);
}


  void disconnectSockets() {
   
    _messageSocket.disconnect();
    _notifSocket.disconnect();
  }

  // --------------------------------------------------------------------
  // 🔔 Bildirim işlemleri
  // --------------------------------------------------------------------
  Future<void> fetchNotifications() async {
    _loading = true;
    notifyListeners();
    try {
      _notifications = await repo.getNotifications();
    } catch (e) {
     
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnreadSummary() async {
    try {
      _unreadSummary = await repo.getUnreadSummary();
      notifyListeners();
    } catch (e) {
     
    }
  }

  Future<void> initUnreadMessageCount() async {
    try {
      _unreadMessageCount = await messageRepo.getUnreadCount();
     
      notifyListeners();
    } catch (e) {
   
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repo.markAllAsRead();
      _notifications = _notifications.map((n) {
        return AppNotification(
          id: n.id,
          type: n.type,
          message: n.message,
          isRead: true,
          createdAt: n.createdAt,
          sender: n.sender,
          data: n.data,
        );
      }).toList();

      _unreadSummary = {'totalUnread': 0, 'byType': {}};
      notifyListeners();
    } catch (e) {
     
    }
  }

  Future<void> markTypeAsRead(String type) async {
    try {
      final result = await repo.markTypeAsRead(type);
      if (result.containsKey('unreadSummary')) {
        _unreadSummary = Map<String, dynamic>.from(result['unreadSummary']);
      }
      notifyListeners();
    } catch (e) {
     
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await repo.markAsRead(id);
      _notifications = _notifications.map((n) {
        if (n.id == id) {
          return AppNotification(
            id: n.id,
            type: n.type,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
            sender: n.sender,
            data: n.data,
          );
        }
        return n;
      }).toList();

      await fetchUnreadSummary();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Tek bildirim okuma hatası: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await repo.clearAll();
      _notifications = [];
      _unreadSummary = {'totalUnread': 0, 'byType': {}};
      _unreadMessageCount = 0;
      notifyListeners();
    } catch (e) {
      
    }
  }
}
