import 'package:wetieko/data/response/follow/follow_status_item_response.dart';

class FollowStatusResponse {
  final bool isSuccess;
  final String? message;
  final FollowStatusItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  FollowStatusResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FollowStatusResponse.fromJson(Map<String, dynamic> json) {
    return FollowStatusResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is Map<String, dynamic>)
          ? FollowStatusItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
