import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/sources/subscription_remote_data_source.dart';
import 'package:Wetieko/models/subscription_model.dart';

class SubscriptionRepository {
  final SubscriptionRemoteDataSource remote;

  SubscriptionRepository(this.remote);

  /// ✅ Satın alma doğrulaması → backend data wrapper
  Future<Subscription?> verifySubscription({
    required String platform,
    required String plan,
    String? receipt,
    String? purchaseToken,
    String? providerProductId,
  }) async {
    debugPrint('📡 [SubscriptionRepo] verifySubscription() çağrıldı...');

    final res = await remote.verifySubscription(
      platform: platform,
      plan: plan,
      receipt: receipt,
      purchaseToken: purchaseToken,
      providerProductId: providerProductId,
    );

    debugPrint('📥 [SubscriptionRepo] Yanıt alındı: ${res.data}');

    final raw = res.data;

    if (raw == null || raw['data'] == null) {
      debugPrint('⚠️ [SubscriptionRepo] Backend data null döndü.');
      return null;
    }

    final subscription = Subscription.fromJson(raw['data']);

    debugPrint(
        '✅ [SubscriptionRepo] Abonelik doğrulandı → plan: ${subscription.plan}');

    return subscription;
  }

  /// ✅ Aktif aboneliği getir (/me)
  Future<Subscription?> getMySubscription() async {
    try {
      debugPrint('📡 [SubscriptionRepo] /subscriptions/me çağrılıyor...');

      final res = await remote.getMySubscription();
      final raw = res.data;

      if (raw == null) {
        debugPrint('ℹ️ [SubscriptionRepo] Response null → abonelik yok.');
        return null;
      }

      if (raw is! Map<String, dynamic>) {
        debugPrint(
            '⚠️ [SubscriptionRepo] Beklenmeyen response tipi: ${raw.runtimeType}');
        return null;
      }

      if (raw['data'] == null) {
        debugPrint('ℹ️ [SubscriptionRepo] Kullanıcının aktif aboneliği yok.');
        return null;
      }

      final subscription = Subscription.fromJson(raw['data']);

      debugPrint(
          '✅ [SubscriptionRepo] Abonelik yüklendi → plan: ${subscription.plan}');

      return subscription;
    } catch (e, s) {
      debugPrint('❌ [SubscriptionRepo] getMySubscription hata: $e');
      debugPrint('🪜 Stack Trace: $s');
      return null;
    }
  }
}
