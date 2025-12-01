import 'package:wetieko/data/response/users/user_item_response.dart';

class ProfileViewListResponse {
  final bool isSuccess;
  final String? message;
  final List<ProfileViewItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  ProfileViewListResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory ProfileViewListResponse.fromJson(Map<String, dynamic> json) {
    return ProfileViewListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => ProfileViewItemResponse.fromJson(e))
          .toList(),
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class ProfileViewItemResponse {
  final int id;
  final int viewerId;
  final int viewedUserId;
  final DateTime createdAt;
  final UserItemResponse? viewer;
  final UserItemResponse? viewedUser;

  ProfileViewItemResponse({
    required this.id,
    required this.viewerId,
    required this.viewedUserId,
    required this.createdAt,
    required this.viewer,
    required this.viewedUser,
  });

  factory ProfileViewItemResponse.fromJson(Map<String, dynamic> json) {
    return ProfileViewItemResponse(
      id: json["id"] ?? 0,
      viewerId: json["viewerId"] ?? 0,
      viewedUserId: json["viewedUserId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      viewer: json["viewer"] != null && json["viewer"] is Map
          ? UserItemResponse.fromJson(json["viewer"])
          : null,
      viewedUser: json["viewedUser"] != null && json["viewedUser"] is Map
          ? UserItemResponse.fromJson(json["viewedUser"])
          : null,
    );
  }
}
