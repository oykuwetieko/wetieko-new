import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/fcm_token.dart';

class FcmTokenRemoteDataSource {
  final ApiService api;

  FcmTokenRemoteDataSource(this.api);

  /// 🔹 Tüm FCM token’larını getir
  Future<List<FcmToken>> getTokens() async {
    final response = await api.get('/api/fcm-tokens');

    final map = response.data;

    if (map is! Map) {
      throw Exception("Beklenmeyen format: Response Map olmalı.");
    }

    final List items = map['data'] ?? [];

    return items.map((t) => FcmToken.fromJson(t)).toList();
  }

  /// 🔹 Yeni token kaydet veya var olanı güncelle
  Future<void> createOrUpdateToken(String token) async {
    await api.post('/api/fcm-tokens', {'token': token});
  }

  /// 🔹 Token güncelleme (eski → yeni)
  Future<void> updateToken(String oldToken, String newToken) async {
    await api.patch('/api/fcm-tokens', {
      'oldToken': oldToken,
      'newToken': newToken,
    });
  }
}
