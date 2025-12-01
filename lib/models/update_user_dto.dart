class UpdateUserDto {
  final String? name;
  final DateTime? birthDate;
  final String? gender;
  final String? location;
  final List<String>? usagePreference;
  final List<String>? industry;
  final List<String>? careerPosition;
  final String? careerStage;
  final List<String>? workEnvironment;
  final List<String>? skills;
  final String? profileImage;       // 🔥 optional
  final String? language;           // 🔥 optional

  UpdateUserDto({
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
    this.profileImage,   // ❗ required değil
    this.language,       // ❗ required değil
  });

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.year.toString().padLeft(4, '0')}-"
           "${date.month.toString().padLeft(2, '0')}-"
           "${date.day.toString().padLeft(2, '0')}T00:00:00";
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (birthDate != null) 'birthDate': _formatDate(birthDate),
      if (gender != null) 'gender': gender,
      if (location != null) 'location': location,
      if (usagePreference != null) 'usagePreference': usagePreference,
      if (industry != null) 'industry': industry,
      if (careerPosition != null) 'careerPosition': careerPosition,
      if (careerStage != null) 'careerStage': careerStage,
      if (workEnvironment != null) 'workEnvironment': workEnvironment,
      if (skills != null) 'skills': skills,
      if (profileImage != null) 'profileImage': profileImage,
      if (language != null) 'language': language,
    };
  }
}
