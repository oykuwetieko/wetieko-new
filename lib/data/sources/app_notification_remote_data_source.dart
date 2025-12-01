import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/app_notification.dart';

class AppNotificationRemoteDataSource {
  final ApiService api;
  AppNotificationRemoteDataSource(this.api);

  /// 🔹 Tüm bildirimleri getir
  Future<List<AppNotification>> getNotifications() async {
    final endpoint = '/api/notifications';

    try {
      final res = await api.get(endpoint);

      if (res.data is! Map<String, dynamic>) {
        throw Exception("Beklenmeyen format: Response Map olmalı.");
      }

      final map = res.data as Map<String, dynamic>;
      final list = map["data"];

      if (list is! List) {
        throw Exception("Beklenmeyen format: data List olmalı.");
      }

      final notifications = list
          .map((e) => AppNotification.fromJson(e))
          .toList();

      return notifications;

    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Okunmamış özet bilgisi
  Future<Map<String, dynamic>> getUnreadSummary() async {
    const endpoint = '/api/notifications/unread/summary';

    try {
      final res = await api.get(endpoint);

      if (res.data is! Map<String, dynamic>) {
        throw Exception("Beklenmeyen format: Response Map olmalı.");
      }

      final map = Map<String, dynamic>.from(res.data);
      final data = map["data"];

      if (data is! Map<String, dynamic>) {
        throw Exception("Beklenmeyen format: data Map olmalı.");
      }

      return data;

    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Belirli tipi okundu yap
  Future<Map<String, dynamic>> markTypeAsRead(String type) async {
    final endpoint = '/api/notifications/type/$type/read';

    try {
      final res = await api.post(endpoint, {});

      if (res.data is! Map<String, dynamic>) {
        throw Exception("Beklenmeyen format");
      }

      final map = Map<String, dynamic>.from(res.data);
      return map;

    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Tek bir bildirimi okundu yap
  Future<void> markAsRead(String id) async {
    final endpoint = '/api/notifications/$id/read';

    try {
      final res = await api.post(endpoint, {});

      if (res.data is! Map) {
        throw Exception("Beklenmeyen format");
      }

    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Tüm bildirimleri okundu yap
  Future<void> markAllAsRead() async {
    try {
      await api.patch('/api/notifications/mark-read', {});
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Tüm bildirimleri sil
  Future<void> clearAll() async {
    try {
      await api.delete('/api/notifications/clear');
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Yeni bildirim oluştur
  Future<void> createNotification(Map<String, dynamic> body) async {
    try {
      await api.post('/api/notifications', body);
    } catch (e) {
      rethrow;
    }
  }
}
