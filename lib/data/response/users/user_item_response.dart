class UserItemResponse {
  final int id;
  final String email;
  final String name;
  final DateTime? birthDate;
  final String gender;
  final String location;
  final List<String> usagePreference;
  final List<String> industry;
  final List<String> careerPosition;
  final String careerStage;
  final List<String> workEnvironment;
  final List<String> skills;
  final String profileImage;
  final String language;
  final String provider;
  final DateTime? createdAt;

  UserItemResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.location,
    required this.usagePreference,
    required this.industry,
    required this.careerPosition,
    required this.careerStage,
    required this.workEnvironment,
    required this.skills,
    required this.profileImage,
    required this.language,
    required this.provider,
    required this.createdAt,
  });

  factory UserItemResponse.fromJson(Map<String, dynamic> json) {
    return UserItemResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      usagePreference:
          (json['usagePreference'] as List<dynamic>? ?? []).cast<String>(),
      industry: (json['industry'] as List<dynamic>? ?? []).cast<String>(),
      careerPosition:
          (json['careerPosition'] as List<dynamic>? ?? []).cast<String>(),
      careerStage: json['careerStage'] ?? '',
      workEnvironment:
          (json['workEnvironment'] as List<dynamic>? ?? []).cast<String>(),
      skills: (json['skills'] as List<dynamic>? ?? []).cast<String>(),
      profileImage: json['profileImage'] ?? '',
      language: json['language'] ?? '',
      provider: json['provider'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
