import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveToken(String accessToken, String refreshToken) async {

  final prefs = await SharedPreferences.getInstance();

  final accessResult = await prefs.setString(_accessTokenKey, accessToken);
  final refreshResult = await prefs.setString(_refreshTokenKey, refreshToken);

  final savedAccess = prefs.getString(_accessTokenKey);
  final savedRefresh = prefs.getString(_refreshTokenKey);
}

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }


  Future<Map<String, String?>> getBothTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "accessToken": prefs.getString(_accessTokenKey),
      "refreshToken": prefs.getString(_refreshTokenKey),
    };
  }


  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_accessTokenKey) &&
        prefs.containsKey(_refreshTokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    print('🧹 Tokenlar silindi.');
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🧼 Tüm SharedPreferences temizlendi.');
  }
}
