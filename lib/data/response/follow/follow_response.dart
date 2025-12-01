import 'package:wetieko/data/response/follow/follow_item_response.dart';

class FollowResponse {
  final bool isSuccess;
  final String? message;
  final FollowItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  FollowResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FollowResponse.fromJson(Map<String, dynamic> json) {
    return FollowResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? FollowItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
