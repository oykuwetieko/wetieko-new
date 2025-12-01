import 'package:Wetieko/data/sources/auth_remote_data_source.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'package:Wetieko/models/login_request_dto.dart'; 

class AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorageService _storage = TokenStorageService();

  AuthRepository(this.remote);

  Future<UserModel> loginWithGoogle(LoginRequestDto dto) async {
    final userModel = await remote.loginWithGoogle(dto);
    await _storage.saveToken(userModel.accessToken, userModel.refreshToken);
    return userModel;
  }

  Future<UserModel> loginWithApple(LoginRequestDto dto) async {
    final userModel = await remote.loginWithApple(dto); 
    await _storage.saveToken(userModel.accessToken, userModel.refreshToken);
    return userModel;
  }
}
