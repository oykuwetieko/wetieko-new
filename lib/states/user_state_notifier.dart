import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'user_state.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/data/repositories/auth_repository.dart';
import 'package:Wetieko/data/repositories/user_repository.dart';
import 'package:Wetieko/data/constants/city_list.dart';

class UserStateNotifier extends ChangeNotifier {
  final AuthRepository authRepo;
  final UserRepository userRepo;

  UserStateNotifier({
    required this.authRepo,
    required this.userRepo,
  });

  UserState _state = const UserState();
  UserState get state => _state;

  User? get user => _state.user;

  List<User> _allUsers = [];
  List<User> get allUsers => _allUsers;

  Future<void> fetchAllUsers() async {
    try {
      final users = await userRepo.getAllUsers();
      _allUsers = users;
      notifyListeners();
    } catch (_) {}
  }

  void setAuthProvider(String provider) {
    _state = _state.copyWith(authProvider: provider);
    notifyListeners();
  }

  void setAppleIdToken(String token) {
    _state = _state.copyWith(appleIdToken: token);
    notifyListeners();
  }

  void setGoogleIdToken(String token) {
    _state = _state.copyWith(googleIdToken: token);
    notifyListeners();
  }

  void setFullName(String name) {
    _state = _state.copyWith(fullName: name);
    notifyListeners();
  }

  /// 🔥 Doğum tarihi artık DateTime
  void setBirthDate(DateTime? date) {
    _state = _state.copyWith(birthDate: date);
    notifyListeners();
  }

  void setGender(String gender) {
    _state = _state.copyWith(gender: gender);
    notifyListeners();
  }

  void setLanguage(String langCode) {
    _state = _state.copyWith(language: langCode);
    notifyListeners();
  }

  void setLocationInfo({
    required bool permission,
    String? city,
    String? district,
    double? latitude,
    double? longitude,
  }) {
    _state = _state.copyWith(
      locationPermission: permission,
      city: city,
      district: district,
      latitude: latitude,
      longitude: longitude,
    );
    notifyListeners();
  }

  void setNotificationPermission(bool permission) {
    _state = _state.copyWith(notificationPermission: permission);
    notifyListeners();
  }

  void setUsagePurposes(List<String> purposes) {
    _state = _state.copyWith(usagePurposes: purposes);
    notifyListeners();
  }

  void setSectors(List<String> sectors) {
    _state = _state.copyWith(sectors: sectors);
    notifyListeners();
  }

  void setPositions(List<String> positions) {
    _state = _state.copyWith(positions: positions);
    notifyListeners();
  }

  void setSkills(List<String> skills) {
    _state = _state.copyWith(skills: skills);
    notifyListeners();
  }

  void setExperienceLevel(String level) {
    _state = _state.copyWith(experienceLevel: level);
    notifyListeners();
  }

  void setWorkEnvironments(List<String> environments) {
    _state = _state.copyWith(workEnvironments: environments);
    notifyListeners();
  }

  void setProfileImage(String imageUrl) {
    _state = _state.copyWith(profileImage: imageUrl);
    notifyListeners();
  }

  Future<void> updateProfileImage(File? file) async {
    if (file != null) {
      final token = await TokenStorageService().getToken();

      if (token == null || token.isEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final localPath = '${dir.path}/temp_profile.jpg';
        await file.copy(localPath);
        _state = _state.copyWith(profileImage: localPath);
      } else {
        _state = _state.copyWith(profileImage: file.path);
        notifyListeners();

        await userRepo.uploadProfilePhoto(file);
        final refreshedUser = await userRepo.getMe();
        setUser(refreshedUser);
        return;
      }
    } else {
      final token = await TokenStorageService().getToken();
      if (token != null && token.isNotEmpty) {
        await userRepo.deleteProfilePhoto();
      }
      _state = _state.copyWith(profileImage: null);
    }

    notifyListeners();
  }

  /// 🔥 Backend’ten gelen kullanıcıyı state’e taşır
  void setUser(User user) async {
    final storedToken = await TokenStorageService().getToken();

    final parsedCity = user.location.split(',').first.trim();
    final validCity =
        cityList.contains(parsedCity) ? parsedCity : "İstanbul";

    final currentLang = user.language.isNotEmpty
        ? user.language
        : ui.window.locale.languageCode;

    final userWithToken = User(
      id: user.id,
      email: user.email,
      name: user.name,
      birthDate: user.birthDate,   
      gender: user.gender,
      location: user.location,
      usagePreference: user.usagePreference,
      industry: user.industry,
      careerPosition: user.careerPosition,
      careerStage: user.careerStage,
      workEnvironment: user.workEnvironment,
      skills: user.skills,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      accessToken: storedToken ?? "",
      isPremium: user.isPremium,
      isBlockedByMe: user.isBlockedByMe,
      language: currentLang,
    );

    _state = _state.copyWith(
      user: userWithToken,
      fullName: user.name,
      birthDate: user.birthDate,  
      gender: user.gender,
      city: validCity,
      usagePurposes: user.usagePreference,
      sectors: user.industry,
      positions: user.careerPosition,
      experienceLevel: user.careerStage,
      workEnvironments: user.workEnvironment,
      skills: user.skills,
      profileImage: user.profileImage,
      isPremium: user.isPremium,
      isBlockedByMe: user.isBlockedByMe,
      language: currentLang,
    );

    notifyListeners();
  }

  void reset() {
    _state = const UserState();
    _allUsers = [];
    notifyListeners();
  }
}
