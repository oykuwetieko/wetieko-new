import 'package:Wetieko/data/sources/profile_view_remote_data_source.dart';
import 'package:Wetieko/models/profile_view_model.dart';

class ProfileViewRepository {
  final ProfileViewRemoteDataSource remote;

  ProfileViewRepository(this.remote);

  Future<void> recordProfileView(String viewedUserId) {
    return remote.recordProfileView(viewedUserId);
  }

  Future<List<ProfileView>> getProfileViews(String userId) {
    return remote.getProfileViews(userId);
  }
}
