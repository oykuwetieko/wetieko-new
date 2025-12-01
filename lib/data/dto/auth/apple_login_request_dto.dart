class AppleLoginRequestDto {
  final String token;
  final String provider;
  final String name;
  final String birthDate; // ❗ String olmalı, null gönderme
  final String gender;
  final String location;
  final List<String> usagePreference;
  final List<String> industry;
  final List<String> careerPosition;
  final String careerStage;
  final List<String> workEnvironment;
  final List<String> skills;
  final String profileImage; // ❗ null gitmemeli
  final String language;

  AppleLoginRequestDto({
    required this.token,
    required this.provider,
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
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "provider": provider,
      "name": name,
      "birthDate": birthDate,
      "gender": gender,
      "location": location,
      "usagePreference": usagePreference,
      "industry": industry,
      "careerPosition": careerPosition,
      "careerStage": careerStage,
      "workEnvironment": workEnvironment,
      "skills": skills,
      "profileImage": profileImage,
      "language": language,
    };
  }
}
