// 📄 lib/models/login_request_dto.dart

class LoginRequestDto {
  final String token;
  final String provider;
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
  final String? profileImage;
  final String? language;

  LoginRequestDto({
    required this.token,
    required this.provider,
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

  /// 🔥 Backend formatına otomatik çevirici (yyyy-MM-dd)
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.year.toString().padLeft(4, '0')}-"
           "${date.month.toString().padLeft(2, '0')}-"
           "${date.day.toString().padLeft(2, '0')}";
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'provider': provider,
      if (name != null) 'name': name,
      if (birthDate != null) 'birthDate': _formatDate(birthDate), // 🔥 otomatik format
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
