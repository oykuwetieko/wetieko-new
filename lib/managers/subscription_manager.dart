import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:Wetieko/states/subscription_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';

class SubscriptionManager {
  final InAppPurchase _iap = InAppPurchase.instance;
  final Set<String> _productIds = {
    'com.wetieko.premium.monthly',
    'com.wetieko.premium.yearly',
  };

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> init({
    required BuildContext context,
    required VoidCallback onProcessingStart,
    required VoidCallback onProcessingEnd,
    required VoidCallback onSuccess,
  }) async {
    await _completePendingPurchases();
    await _listenToPurchases(context, onProcessingStart, onProcessingEnd, onSuccess);
  }

  Future<List<ProductDetails>> loadProducts() async {
    final available = await _iap.isAvailable();
    if (!available) return [];
    final response = await _iap.queryProductDetails(_productIds);
    return response.productDetails;
  }

  Future<void> buySubscription({
    required BuildContext context,
    required ProductDetails product,
  }) async {
    final userNotifier = Provider.of<UserStateNotifier>(context, listen: false);
    final userId = userNotifier.user?.id ?? const Uuid().v4();
    final param = PurchaseParam(
      productDetails: product,
      applicationUserName: userId,
    );
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  /// ✅ Artık UI içermez — sadece bool döner
  Future<bool> restorePurchases() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) return false;

      final restored = <PurchaseDetails>[];
      final sub = _iap.purchaseStream.listen((purchases) {
        for (final p in purchases) {
          if (p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored) {
            restored.add(p);
          }
        }
      });

      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 2));
      await sub.cancel();

      return restored.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _completePendingPurchases() async {
    final available = await _iap.isAvailable();
    if (!available) return;
    await _iap.restorePurchases();
  }

  Future<void> _listenToPurchases(
    BuildContext context,
    VoidCallback onProcessingStart,
    VoidCallback onProcessingEnd,
    VoidCallback onSuccess,
  ) async {
    _subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        await _handlePurchase(
          context,
          purchase,
          onProcessingStart,
          onProcessingEnd,
          onSuccess,
        );
      }
    });
  }

  Future<void> _handlePurchase(
    BuildContext context,
    PurchaseDetails purchase,
    VoidCallback onProcessingStart,
    VoidCallback onProcessingEnd,
    VoidCallback onSuccess,
  ) async {
    if (purchase.status != PurchaseStatus.purchased &&
        purchase.status != PurchaseStatus.restored) return;

    final rawData = purchase.verificationData.serverVerificationData;
    if (rawData.trim().isEmpty ||
        rawData == 'null' ||
        rawData == '(null)' ||
        rawData.contains('NSNull')) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
      return;
    }

    try {
      if (!_contextIsValid(context)) return;

      onProcessingStart();

      final productId = purchase.productID;
      final plan = productId.contains('yearly') ? 'yearly' : 'monthly';
      final token = rawData.trim();
      final platform = Platform.isIOS ? 'ios' : 'android';

      final subscriptionState =
          Provider.of<SubscriptionStateNotifier>(context, listen: false);

      await subscriptionState.verifySubscription(
        platform: platform,
        plan: plan,
        receipt: Platform.isIOS ? token : null,
        purchaseToken: Platform.isAndroid ? token : null,
        providerProductId: productId,
      );

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      onProcessingEnd();
      onSuccess();
    } catch (_) {
      onProcessingEnd();
    }
  }

  bool _contextIsValid(BuildContext context) {
    try {
      return context.findRenderObject()?.attached ?? false;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
