import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/sources/follow_remote_data_source.dart';
import 'package:Wetieko/models/follow_model.dart';

class FollowRepository {
  final FollowRemoteDataSource remote;

  FollowRepository(this.remote);

  /// ✅ Takip isteği gönder
  Future<void> sendFollowRequest(String userId) {
  
    return remote.sendFollowRequest(userId);
  }

  /// ✅ Takip isteği durumunu güncelle (accept/reject)
  Future<void> updateFollowStatus(String followId, String status) {
   
    return remote.updateFollowStatus(followId, status);
  }

  /// ✅ Takipten çık
  Future<void> unfollow(String userId) {
   
    return remote.unfollow(userId);
  }

  /// ✅ Takipçiyi kaldır
  Future<void> removeFollower(String userId) {
   
    return remote.removeFollower(userId);
  }

  /// ✅ Bekleyen takip isteğini iptal et
  Future<void> cancelFollowRequest(String userId) {
    debugPrint("📡 Repository -> cancelFollowRequest($userId)");
    return remote.cancelFollowRequest(userId);
  }

  /// ✅ Takipçileri getir
  Future<List<FollowModel>> getFollowers(String userId) {
    
    return remote.getFollowers(userId);
  }

  /// ✅ Takip ettiklerini getir
  Future<List<FollowModel>> getFollowing(String userId) {
   
    return remote.getFollowing(userId);
  }

  /// ✅ Bekleyen takip isteklerini çek (incoming requests)
  Future<List<FollowModel>> getPendingRequests() {
   
    return remote.getPendingRequests();
  }

  /// ✅ Takip isteğimi kimlerin kabul ettiğini getir
  Future<List<FollowModel>> getAcceptedRequests() {
   
    return remote.getAcceptedRequests();
  }

  /// 🔹 İki kullanıcı arasındaki takip durumunu getir
  Future<String> getFollowStatus(String followingId) {
   
    return remote.getFollowStatus(followingId);
  }
}
