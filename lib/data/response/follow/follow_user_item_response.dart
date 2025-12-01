class FollowUserItemResponse {
  final int id;
  final String email;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String? location;
  final List<String>? usagePreference;
  final List<String>? industry;
  final List<String>? careerPosition;
  final String? careerStage;
  final List<String>? workEnvironment;
  final List<String>? skills;
  final String? profileImage;
  final String? language;
  final String? provider;
  final DateTime createdAt;

  FollowUserItemResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.location,
    this.usagePreference,
    this.industry,
    this.careerPosition,
    this.careerStage,
    this.workEnvironment,
    this.skills,
    this.profileImage,
    this.language,
    this.provider,
    required this.createdAt,
  });

  factory FollowUserItemResponse.fromJson(Map<String, dynamic> json) {
    return FollowUserItemResponse(
      id: json["id"] ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      birthDate: DateTime.tryParse(json["birthDate"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      gender: json["gender"] ?? "",
      location: json["location"],
      usagePreference: (json["usagePreference"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      industry:
          (json["industry"] as List?)?.map((e) => e.toString()).toList(),
      careerPosition: (json["careerPosition"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      careerStage: json["careerStage"],
      workEnvironment: (json["workEnvironment"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      skills:
          (json["skills"] as List?)?.map((e) => e.toString()).toList(),
      profileImage: json["profileImage"],
      language: json["language"],
      provider: json["provider"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
