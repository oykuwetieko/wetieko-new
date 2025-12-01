import 'package:wetieko/data/response/users/user_item_response.dart';

class GoogleLoginResponse {
  final bool isSuccess;
  final String? message;
  final GoogleLoginData? data;
  final List<String>? errors;
  final String? errorCode;

  GoogleLoginResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null ? GoogleLoginData.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
      errorCode: json['errorCode'],
    );
  }
}

class GoogleLoginData {
  final String accessToken;
  final String refreshToken;
  final String expiresAt;
  final UserItemResponse user;

  GoogleLoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory GoogleLoginData.fromJson(Map<String, dynamic> json) {
    return GoogleLoginData(
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      expiresAt: json['expiresAt'] ?? "",
      user: UserItemResponse.fromJson(json['user']),
    );
  }
}
