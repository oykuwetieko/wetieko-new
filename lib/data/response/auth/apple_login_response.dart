import 'package:wetieko/data/response/users/user_item_response.dart';

class AppleLoginResponse {
  final bool isSuccess;
  final String? message;
  final AppleLoginData? data;
  final List<String>? errors;
  final String? errorCode;

  AppleLoginResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory AppleLoginResponse.fromJson(Map<String, dynamic> json) {
    return AppleLoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null ? AppleLoginData.fromJson(json['data']) : null,
      errors:
          json['errors'] != null ? List<String>.from(json['errors']) : null,
      errorCode: json['errorCode'],
    );
  }
}

class AppleLoginData {
  final String accessToken;
  final String refreshToken;
  final String expiresAt;
  final UserItemResponse user;

  AppleLoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory AppleLoginData.fromJson(Map<String, dynamic> json) {
    return AppleLoginData(
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      expiresAt: json['expiresAt'] ?? "",
      user: UserItemResponse.fromJson(json['user']),
    );
  }
}
