import 'package:wetieko/data/response/follow/follow_item_response.dart';

class FollowAcceptedListResponse {
  final bool isSuccess;
  final String? message;
  final List<FollowItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  FollowAcceptedListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory FollowAcceptedListResponse.fromJson(Map<String, dynamic> json) {
    return FollowAcceptedListResponse(
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
