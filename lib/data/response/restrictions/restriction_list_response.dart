import 'package:wetieko/data/response/users/user_item_response.dart';

class RestrictionListResponse {
  final bool isSuccess;
  final String? message;
  final List<RestrictionItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  RestrictionListResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory RestrictionListResponse.fromJson(Map<String, dynamic> json) {
    return RestrictionListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => RestrictionItemResponse.fromJson(e))
          .toList(),
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class RestrictionItemResponse {
  final int id;
  final int blockerId;
  final int blockedId;
  final DateTime createdAt;

  final UserItemResponse blocker;
  final UserItemResponse blocked;

  RestrictionItemResponse({
    required this.id,
    required this.blockerId,
    required this.blockedId,
    required this.createdAt,
    required this.blocker,
    required this.blocked,
  });

  factory RestrictionItemResponse.fromJson(Map<String, dynamic> json) {
    return RestrictionItemResponse(
      id: json["id"] ?? 0,
      blockerId: json["blockerId"] ?? 0,
      blockedId: json["blockedId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      blocker: UserItemResponse.fromJson(json["blocker"]),
      blocked: UserItemResponse.fromJson(json["blocked"]),
    );
  }
}
