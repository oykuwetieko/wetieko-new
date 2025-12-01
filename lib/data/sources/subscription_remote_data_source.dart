import 'package:Wetieko/core/services/api_service.dart';
import 'package:dio/dio.dart';

class SubscriptionRemoteDataSource {
  final ApiService api;

  SubscriptionRemoteDataSource(this.api);

  
  int _mapPlatform(String platform) {
    final mapped = platform.toLowerCase() == 'ios' ? 0 : 1;
   
    return mapped;
  }

 
  int _mapPlan(String plan) {
    final mapped = plan == 'yearly' ? 1 : 0;
   
    return mapped;
  }

  
  Future<Response> verifySubscription({
    required String platform, 
    required String plan, 
    String? receipt,
    String? purchaseToken, 
    String? providerProductId, 
  }) async {
   

    final data = {
      'platform': _mapPlatform(platform), 
      'plan': _mapPlan(plan),
      if (receipt != null) 'receipt': receipt,
      if (purchaseToken != null) 'purchaseToken': purchaseToken,
      if (providerProductId != null) 'providerProductId': providerProductId,
    };
    try {
      final response = await api.post('/api/subscriptions/verify', data);

      return response;
    } catch (e, s) {
     
      rethrow;
    }
  }

  Future<Response> getMySubscription() async {
  
    try {
      final response = await api.get('/api/subscriptions/me');

      return response;
    } catch (e, s) {
     
      rethrow;
    }
  }
}
