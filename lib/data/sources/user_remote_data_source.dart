import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/models/update_user_dto.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class UserRemoteDataSource {
  final ApiService api;

  UserRemoteDataSource(this.api);

  Future<User> getMe() async {


    try {
      final response = await api.get('/api/Users/current');
      final raw = response.data;
      final data = raw['data'];

      final user = User.fromJson(data);
      return user;
    } catch (e) {
     
      rethrow;
    }
  }


Future<User> updateMe(UpdateUserDto dto) async {
  try {
   
    final response = await api.post('/api/Users/current', dto.toJson());

    final userModel = UserModel.fromCurrentJson(response.data);

    return userModel.user;
  } catch (e, stackTrace) {
    
    rethrow;
  }
}


  Future<void> deleteAccount() async {

  try {


    final response = await api.post('/api/Users/delete/current', {});

    final data = response.data;

  } catch (e, stackTrace) {
  
    rethrow;
  }
}



  Future<List<User>> getAllUsers() async {
   
    try {
      final response = await api.get('/api/Users');

      final raw = response.data;
      final List<dynamic> list = raw['data'] ?? [];
      final users = list.map((json) => User.fromJson(json)).toList();

      return users;
    } catch (e) {
     
      rethrow;
    }
  }


 Future<String> uploadProfilePhoto(File file) async {

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });

  try {
    final response = await api.post('/api/uploads/profile', formData);

    final url = response.data['data']['url'];
    return url;
  } catch (e) {

    rethrow;
  }
}


Future<void> deleteProfilePhoto() async {

  try {
    final response = await api.post('/api/uploads/delete/profile', {});

    final data = response.data;
  } catch (e) {
   
    rethrow;
  }
}
}
