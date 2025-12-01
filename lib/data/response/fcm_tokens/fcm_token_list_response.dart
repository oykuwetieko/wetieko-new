import 'package:wetieko/data/response/fcm_tokens/fcm_token_item_response.dart';

class FcmTokenListResponse {
  final bool isSuccess;
  final String? message;
  final List<FcmTokenItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  FcmTokenListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FcmTokenListResponse.fromJson(Map<String, dynamic> json) {
    return FcmTokenListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is List)
          ? (json["data"] as List)
              .map((e) => FcmTokenItemResponse.fromJson(e))
              .toList()
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
