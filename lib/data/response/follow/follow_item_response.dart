import 'package:wetieko/data/response/follow/follow_user_item_response.dart';

class FollowItemResponse {
  final int id;
  final int followerId;
  final int followingId;
  final String status;
  final DateTime createdAt;
  final FollowUserItemResponse? follower;
  final FollowUserItemResponse? following;

  FollowItemResponse({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.status,
    required this.createdAt,
    this.follower,
    this.following,
  });

  factory FollowItemResponse.fromJson(Map<String, dynamic> json) {
    return FollowItemResponse(
      id: json["id"] ?? 0,
      followerId: json["followerId"] ?? 0,
      followingId: json["followingId"] ?? 0,
      status: json["status"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      follower: json["follower"] is Map<String, dynamic>
          ? FollowUserItemResponse.fromJson(json["follower"])
          : null,
      following: json["following"] is Map<String, dynamic>
          ? FollowUserItemResponse.fromJson(json["following"])
          : null,
    );
  }
}
