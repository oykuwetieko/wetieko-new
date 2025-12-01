class GetUserByIdResponse {
  final bool isSuccess;
  final String? message;
  final UserByIdData? data;
  final List<String>? errors;
  final String? errorCode;

  GetUserByIdResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory GetUserByIdResponse.fromJson(Map<String, dynamic> json) {
    return GetUserByIdResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null
          ? UserByIdData.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class UserByIdData {
  final int id;
  final String email;
  final String name;
  final String? profileImage;
  final String language;
  final DateTime birthDate;
  final String gender;
  final String location;
  final List<String> usagePreference;
  final List<String> industry;
  final List<String> careerPosition;
  final String careerStage;
  final List<String> workEnvironment;
  final List<String> skills;
  final String provider;
  final DateTime createdAt;

  UserByIdData({
    required this.id,
    required this.email,
    required this.name,
    required this.profileImage,
    required this.language,
    required this.birthDate,
    required this.gender,
    required this.location,
    required this.usagePreference,
    required this.industry,
    required this.careerPosition,
    required this.careerStage,
    required this.workEnvironment,
    required this.skills,
    required this.provider,
    required this.createdAt,
  });

  factory UserByIdData.fromJson(Map<String, dynamic> json) {
    return UserByIdData(
      id: json["id"] ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      profileImage: json["profileImage"],
      language: json["language"] ?? "",
      birthDate: DateTime.tryParse(json["birthDate"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      gender: json["gender"] ?? "",
      location: json["location"] ?? "",
      usagePreference:
          List<String>.from(json["usagePreference"] ?? const []),
      industry: List<String>.from(json["industry"] ?? const []),
      careerPosition: List<String>.from(json["careerPosition"] ?? const []),
      careerStage: json["careerStage"] ?? "",
      workEnvironment: List<String>.from(json["workEnvironment"] ?? const []),
      skills: List<String>.from(json["skills"] ?? const []),
      provider: json["provider"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
