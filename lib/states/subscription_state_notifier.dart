import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/data/repositories/subscription_repository.dart';
import 'package:Wetieko/models/subscription_model.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/main.dart';

class SubscriptionStateNotifier extends ChangeNotifier {
  final SubscriptionRepository repo;

  Subscription? current;

  SubscriptionStateNotifier(this.repo);

  bool get isPremium {
    final active = current?.isActive ?? false;
  
    return active;
  }

  String get plan => current?.plan ?? 'free';

  
  Future<void> verifySubscription({
    required String platform,
    required String plan,
    String? receipt,
    String? purchaseToken,
    String? providerProductId,
  }) async {
    

    try {
      final result = await repo.verifySubscription(
        platform: platform,
        plan: plan,
        receipt: receipt,
        purchaseToken: purchaseToken,
        providerProductId: providerProductId,
      );

      if (result == null) {
        debugPrint('⚠️ [SubscriptionState] Backend doğrulama null döndü.');
        return;
      }

      current = result;

      debugPrint(
        '✅ [SubscriptionState] Abonelik doğrulandı → plan=${current?.plan}, aktif=${current?.isActive}',
      );

      _syncUserPremiumStatus();
      notifyListeners();
    } catch (e, s) {
      debugPrint('❌ [SubscriptionState] verifySubscription hata: $e');
      debugPrint('🪜 Stack: $s');
      rethrow;
    }
  }

  
  Future<void> fetchMySubscription() async {
    debugPrint('🔄 [SubscriptionState] fetchMySubscription çağrıldı...');

    try {
      final result = await repo.getMySubscription();

      current = result;

      if (result == null) {
        debugPrint('ℹ️ [SubscriptionState] Aktif abonelik bulunamadı.');
      } else {
        debugPrint(
          '📄 [SubscriptionState] Aktif abonelik bulundu → plan=${result.plan}, aktif=${result.isActive}',
        );
      }

      _syncUserPremiumStatus();
      notifyListeners();
    } catch (e, s) {
     
    }
  }

  /// 🔄 UserState ile premium durumunu eşitle
  void _syncUserPremiumStatus() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('⚠️ [SubscriptionState] Context null → sync atlandı.');
      return;
    }

    try {
      final userNotifier = Provider.of<UserStateNotifier>(ctx, listen: false);
      final user = userNotifier.user;

      if (user == null) {
        debugPrint('ℹ️ [SubscriptionState] Oturumdaki kullanıcı yok.');
        return;
      }

      final active = current?.isActive ?? false;

      if (user.isPremium == active) {
        debugPrint(
            'ℹ️ [SubscriptionState] User premium durumu zaten güncel ($active).');
        return;
      }


      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: user.name,
        birthDate: user.birthDate,
        age: user.age,
        gender: user.gender,
        location: user.location,
        usagePreference: user.usagePreference,
        industry: user.industry,
        careerPosition: user.careerPosition,
        careerStage: user.careerStage,
        workEnvironment: user.workEnvironment,
        skills: user.skills,
        profileImage: user.profileImage,
        createdAt: user.createdAt,
        accessToken: user.accessToken,
        isPremium: active,
      );

      userNotifier.setUser(updatedUser);
    } catch (e) {
      debugPrint('⚠️ [SubscriptionState] User sync hatası: $e');
    }
  }

  
  void clear() {
   
    current = null;
    _syncUserPremiumStatus();
    notifyListeners();
  }
}
