import 'package:Wetieko/data/sources/fcm_token_remote_data_source.dart';
import 'package:Wetieko/models/fcm_token.dart';

class FcmTokenRepository {
  final FcmTokenRemoteDataSource remote;
  FcmTokenRepository(this.remote);

  Future<List<FcmToken>> getTokens() => remote.getTokens();

  /// 🔹 Artık deviceType parametresi yok
  Future<void> createOrUpdateToken(String token) =>
      remote.createOrUpdateToken(token);

  Future<void> updateToken(String oldToken, String newToken) =>
      remote.updateToken(oldToken, newToken);

  //Future<void> deleteToken(String token) => remote.deleteToken(token);
}
