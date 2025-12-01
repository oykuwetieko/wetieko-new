import 'package:wetieko/data/response/follow/follow_item_response.dart';

class FollowListResponse {
  final bool isSuccess;
  final String? message;
  final List<FollowItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  FollowListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FollowListResponse.fromJson(Map<String, dynamic> json) {
    return FollowListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is List)
          ? (json["data"] as List)
              .map((e) => FollowItemResponse.fromJson(e))
              .toList()
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
