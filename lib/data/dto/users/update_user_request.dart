class UpdateUserRequest {
  final String? name;
  final String? birthDate;
  final String? gender;
  final String? location;
  final List<String>? usagePreference;
  final List<String>? industry;
  final List<String>? careerPosition;
  final String? careerStage;
  final List<String>? workEnvironment;
  final List<String>? skills;
  final String? profileImage;
  final String? language;

  UpdateUserRequest({
    this.name,
    this.birthDate,
    this.gender,
    this.location,
    this.usagePreference,
    this.industry,
    this.careerPosition,
    this.careerStage,
    this.workEnvironment,
    this.skills,
    this.profileImage,
    this.language,
  });

  Map<String, dynamic> toJson() {
    return {
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
