import 'package:Wetieko/data/sources/app_notification_remote_data_source.dart';
import 'package:Wetieko/models/app_notification.dart';

class AppNotificationRepository {
  final AppNotificationRemoteDataSource remote;
  AppNotificationRepository(this.remote);

  /// 🔹 Tüm bildirimleri getir
  Future<List<AppNotification>> getNotifications() =>
      remote.getNotifications();

  /// 🔹 Yeni bildirim oluştur
  Future<void> createNotification(Map<String, dynamic> body) =>
      remote.createNotification(body);

  /// 🔹 Tüm bildirimleri okundu yap
  Future<void> markAllAsRead() => remote.markAllAsRead();

  /// 🔹 Tüm bildirimleri temizle
  Future<void> clearAll() => remote.clearAll();

  /// 🆕 🔹 Okunmamış bildirim özeti (toplam + tür bazlı)
  Future<Map<String, dynamic>> getUnreadSummary() =>
      remote.getUnreadSummary();

  /// 🆕 🔹 Belirli türdeki tüm bildirimleri okundu yap
  Future<Map<String, dynamic>> markTypeAsRead(String type) =>
      remote.markTypeAsRead(type);

  /// 🆕 🔹 Sadece tek bir bildirimi okundu yap
  Future<void> markAsRead(String id) => remote.markAsRead(id);
}
