import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/models/login_request_dto.dart';

class AuthRemoteDataSource {
  final ApiService api;

  AuthRemoteDataSource(this.api);

  Future<UserModel> loginWithGoogle(LoginRequestDto dto) async {
    final response = await api.post('/api/Auth/google', dto.toJson());

    final data = response.data['data'];

    final model = UserModel.fromLoginJson(data);

    return model;
  }

  Future<UserModel> loginWithApple(LoginRequestDto dto) async {
    final response = await api.post('/api/Auth/apple', dto.toJson());

    final data = response.data['data'];

    final model = UserModel.fromLoginJson(data);

    return model;
  }
}
