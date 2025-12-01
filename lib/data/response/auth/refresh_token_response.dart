import 'package:wetieko/data/response/users/user_item_response.dart';

class RefreshTokenResponse {
  final bool isSuccess;
  final String? message;
  final RefreshTokenData? data;
  final List<String>? errors;
  final String? errorCode;

  RefreshTokenResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RefreshTokenData.fromJson(json['data'])
          : null,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : null,
      errorCode: json['errorCode'],
    );
  }
}

class RefreshTokenData {
  final String accessToken;
  final String refreshToken;
  final String expiresAt;
  final UserItemResponse user;

  RefreshTokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      expiresAt: json['expiresAt'] ?? "",
      user: UserItemResponse.fromJson(json['user']),
    );
  }
}
