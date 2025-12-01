import 'package:wetieko/data/response/fcm_tokens/fcm_token_item_response.dart';

class FcmTokenResponse {
  final bool isSuccess;
  final String? message;
  final FcmTokenItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  FcmTokenResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FcmTokenResponse.fromJson(Map<String, dynamic> json) {
    return FcmTokenResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map
          ? FcmTokenItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
