class UserModel {
  final String accessToken;
  final String refreshToken;
  final User user;

  UserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    final access = json['accessToken'] ?? '';

    return UserModel(
      accessToken: access,
      refreshToken: json['refreshToken'] ?? '',
      user: User.fromJson(
        json['user'] ?? {},
        accessToken: access,
      ),
    );
  }

  factory UserModel.fromCurrentJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data == null || data is! Map) {
      throw Exception("Invalid response: 'data' field missing or not a map");
    }

    final safeData = Map<String, dynamic>.from(data);

    return UserModel(
      accessToken: safeData['accessToken'] ?? '',
      refreshToken: safeData['refreshToken'] ?? '',
      user: User.fromJson(safeData),
    );
  }
}

class User {
  final String id; // 🔥 Artık hep String → backend int da gönderse sorun yok
  final String email;
  final String name;

  final DateTime? birthDate;
  final int? age;
  final String gender;
  final String location;

  final List<String> usagePreference;
  final List<String> industry;
  final List<String> careerPosition;
  final String careerStage;
  final List<String> workEnvironment;
  final List<String> skills;

  final String? profileImage;
  final DateTime createdAt;

  final String? accessToken;
  final bool isPremium;
  final bool isBlockedByMe;
  final String language;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.birthDate,
    this.age,
    required this.gender,
    required this.location,
    required this.usagePreference,
    required this.industry,
    required this.careerPosition,
    required this.careerStage,
    required this.workEnvironment,
    required this.skills,
    required this.createdAt,
    this.profileImage,
    this.accessToken,
    this.isPremium = false,
    this.isBlockedByMe = false,
    this.language = 'tr',
  });

  static List<String> _safeList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return [value];
    return [];
  }

  static String _safeCareerStage(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List && value.isNotEmpty) return value.first.toString();
    return '';
  }

  factory User.fromJson(Map<String, dynamic> json, {String? accessToken}) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['fullName'] ?? json['name'] ?? '',
      birthDate: _parseNullableDate(json['birthDate']),
      age: json['age'],
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      usagePreference: _safeList(json['usagePreference']),
      industry: _safeList(json['industry']),
      careerPosition: _safeList(json['careerPosition']),
      careerStage: _safeCareerStage(json['careerStage']),
      workEnvironment: _safeList(json['workEnvironment']),
      skills: _safeList(json['skills']),
      profileImage: json['profileImage'],
      createdAt: _parseDate(json['createdAt']),
      accessToken: accessToken,
      isPremium: json['isPremium'] ?? false,
      isBlockedByMe: json['isBlockedByMe'] ?? false,
      language: json['language'] ?? 'tr',
    );
  }

  static User empty() => User(
        id: '',
        email: '',
        name: '',
        birthDate: null,
        age: null,
        gender: '',
        location: '',
        usagePreference: const [],
        industry: const [],
        careerPosition: const [],
        careerStage: '',
        workEnvironment: const [],
        skills: const [],
        profileImage: null,
        createdAt: DateTime.now(),
        accessToken: null,
        isPremium: false,
        isBlockedByMe: false,
        language: 'tr',
      );

  static DateTime? _parseNullableDate(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return DateTime.now();
  }

  // ⭐⭐⭐ EKLENEN KISIM → HATAYI ÇÖZEN ⭐⭐⭐
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'age': age,
      'gender': gender,
      'location': location,
      'usagePreference': usagePreference,
      'industry': industry,
      'careerPosition': careerPosition,
      'careerStage': careerStage,
      'workEnvironment': workEnvironment,
      'skills': skills,
      'profileImage': profileImage,
      'language': language,
      'isPremium': isPremium,
      'isBlockedByMe': isBlockedByMe,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
