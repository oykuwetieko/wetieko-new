import 'package:Wetieko/core/services/api_service.dart';

class RestrictionRemoteDataSource {
  final ApiService api;

  RestrictionRemoteDataSource(this.api);

  Future<void> restrictUser(dynamic blockedId) async {
    final endpoint = '/api/restrictions/${blockedId.toString()}';
    final body = {};

    try {
      final res = await api.post(endpoint, body);

    } catch (e, stack) {

      rethrow;
    }
  }

  Future<void> unrestrictUser(dynamic blockedId) async {
    final endpoint = '/api/restrictions/delete/${blockedId.toString()}';
    final body = {};

    try {
      final res = await api.post(endpoint, body);

    } catch (e, stack) {
   
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRestrictedUsers() async {
    const endpoint = '/api/restrictions';

    try {
      final res = await api.get(endpoint);

      final dataList = res.data['data'];
      return List<Map<String, dynamic>>.from(dataList);
    } catch (e, stack) {
 
      rethrow;
    }
  }


  Future<bool> checkRestriction(dynamic blockedId) async {
    final endpoint = '/api/restrictions/check/${blockedId.toString()}';

    try {
      final res = await api.get(endpoint);

      final value = res.data["data"];

      return value == true;
    } catch (e, stack) {
     
      rethrow;
    }
  }
}
