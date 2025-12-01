import 'dart:io'; // <-- Eksikti, eklendi
import 'package:Wetieko/data/sources/user_remote_data_source.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/models/update_user_dto.dart'; 

class UserRepository {
  final UserRemoteDataSource remote;

  UserRepository(this.remote);

  Future<User> getMe() {
    return remote.getMe();
  }

  Future<User> updateMe(UpdateUserDto dto) { 
    return remote.updateMe(dto);
  }

  Future<void> deleteMe() {
    return remote.deleteAccount();
  }


  Future<String> uploadProfilePhoto(File file) {
    return remote.uploadProfilePhoto(file);
  }

  Future<void> deleteProfilePhoto() {
    return remote.deleteProfilePhoto();
  }

  /// ✅ Tüm kullanıcıları listele
  Future<List<User>> getAllUsers() {
    return remote.getAllUsers();
  }
}
