import 'package:flutter/foundation.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/follow_model.dart';
import 'package:dio/dio.dart';

class FollowRemoteDataSource {
  final ApiService api;

  FollowRemoteDataSource(this.api);

  Future<void> sendFollowRequest(String userId) async {
    final endpoint = '/api/follows/$userId';
  
    try {
      final res = await api.post(endpoint, {});
      
    } catch (e, s) {
     
      rethrow;
    }
  }

 Future<void> updateFollowStatus(String followId, String status) async {
  final endpoint = '/api/follows/$followId/status';
  final body = {"status": status};

  try {
    final res = await api.post(endpoint, body);

  } on DioException catch (e) {
    rethrow;
  } catch (e, s) {
  
    rethrow;
  }
}


  Future<void> unfollow(String userId) async {
    final endpoint = '/api/follows/delete/$userId';

    try {
      final res = await api.post(endpoint, {});
      print("🟢 RESPONSE (${res.statusCode})");
    } catch (e, s) {
      print("🔴 ERROR → unfollow");
      print("❗ $e");
      print(s);
      rethrow;
    }
  }

  Future<void> removeFollower(String userId) async {
    final endpoint = '/api/follows/delete/remove-follower/$userId';


    try {
      final res = await api.post(endpoint, {});
    
    } catch (e, s) {
      print("🔴 ERROR → removeFollower");
      print("❗ $e");
      print(s);
      rethrow;
    }
  }


  Future<void> cancelFollowRequest(String userId) async {
    final endpoint = '/api/follows/delete/$userId/cancel';

    try {
      final res = await api.post(endpoint, {});
     
    } catch (e, s) {
     
      print("❗ $e");
      print(s);
      rethrow;
    }
  }

 Future<List<FollowModel>> getFollowers(String userId) async {
  final endpoint = '/api/follows/followers/$userId';
  try {
    final res = await api.get(endpoint);
    final map = res.data;
    if (map is! Map<String, dynamic>) {
      throw Exception("Beklenmeyen response formatı");
    }
    final List items = map['data'] ?? [];
    return items.map((e) => FollowModel.fromJson(e)).toList();
  } catch (e, s) {
    
    rethrow;
  }
}

  Future<List<FollowModel>> getFollowing(String userId) async {
  final endpoint = '/api/follows/following/$userId';
  try {
    final res = await api.get(endpoint);
    final map = res.data;

    if (map is! Map<String, dynamic>) {
      throw Exception("Beklenmeyen response formatı");
    }
    final List items = map['data'] ?? [];

    return items.map((e) => FollowModel.fromJson(e)).toList();
  } catch (e, s) {
   
    rethrow;
  }
}

  Future<List<FollowModel>> getPendingRequests() async {
  final endpoint = '/api/follows/pending';

  try {
    final res = await api.get(endpoint);


    // Response Map olmak zorunda (Swagger gereği)
    if (res.data is! Map<String, dynamic>) {
     
      throw Exception("Beklenmeyen response formatı (Map değil)");
    }

    final map = res.data as Map<String, dynamic>;

   
    final list = map["data"];

  

    if (list is! List) {
      print("❌ HATA: map['data'] List değil!");
      throw Exception("Beklenmeyen response formatı (data List değil)");
    }

    final models = list.map((e) {
      print("🔧 PARSING ITEM → $e");
      return FollowModel.fromJson(e);
    }).toList();


    return models;

  } catch (e, s) {
   
    print("=================================================");
    rethrow;
  }
}

  Future<List<FollowModel>> getAcceptedRequests() async {
  final endpoint = '/api/follows/accepted';


  try {
    final res = await api.get(endpoint);


    if (res.data is! Map<String, dynamic>) {
      print("❌ HATA: Response Map formatında değil!");
      throw Exception("Beklenmeyen response formatı (Map değil)");
    }

    final map = res.data as Map<String, dynamic>;
    final list = map["data"];

    if (list is! List) {
      print("❌ HATA: 'data' alanı List formatında değil!");
      throw Exception("Beklenmeyen response formatı (data List değil)");
    }

    final models = list.map((e) {
      print("🔧 PARSING ITEM → $e");
      return FollowModel.fromJson(e);
    }).toList();

    return models;

  } catch (e, s) {
  
    print("=================================================");
    rethrow;
  }
}

 Future<String> getFollowStatus(String followingId) async {
  final endpoint = '/api/follows/status/$followingId';

  try {
    final res = await api.get(endpoint);


    if (res.data is! Map<String, dynamic>) {
      print("❌ HATA: Response Map formatında değil!");
      throw Exception("Beklenmeyen response formatı (Map değil)");
    }

    final map = res.data as Map<String, dynamic>;

    if (map["data"] == null) {
      print("❌ HATA: Response.data boş veya null!");
      throw Exception("Beklenmeyen response formatı (data yok)");
    }

    final status = map["data"]["status"];

    return status ?? "";
  } catch (e, s) {
   
    print("=================================================");
    rethrow;
  }
}

}
