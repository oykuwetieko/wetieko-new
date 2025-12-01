import 'package:Wetieko/data/sources/restriction_remote_data_source.dart';

class RestrictionRepository {
  final RestrictionRemoteDataSource remote;

  RestrictionRepository(this.remote);

  Future<void> restrictUser(String blockedId) =>
      remote.restrictUser(blockedId);

  Future<void> unrestrictUser(String blockedId) =>
      remote.unrestrictUser(blockedId);

  Future<List<Map<String, dynamic>>> getRestrictedUsers() =>
      remote.getRestrictedUsers();

  // 🔥 YENİ
  Future<bool> checkRestriction(String blockedId) =>
      remote.checkRestriction(blockedId);
}
