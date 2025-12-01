import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/profile_view_model.dart';
import 'package:dio/dio.dart';

class ProfileViewRemoteDataSource {
  final ApiService api;

  ProfileViewRemoteDataSource(this.api);

  Future<void> recordProfileView(String viewedUserId) async {
    final endpoint = '/api/profile-views/$viewedUserId';

    try {
      final response = await api.post(endpoint, {});
    } catch (e, s) {
      rethrow;
    }
  }

  Future<List<ProfileView>> getProfileViews(String userId) async {
    final endpoint = '/api/profile-views/$userId';
    try {
      final response = await api.get(endpoint);
      final raw = response.data;
      final list = raw["data"];
      return list.map((json) => ProfileView.fromJson(json)).toList();

    } catch (e, s) {
    
      rethrow;
    }
  }
}
