import 'package:Wetieko/models/user_model.dart';

class ProfileView {
  final int id;
  final int viewerId;
  final int viewedUserId;
  final DateTime createdAt;
  final User viewer;
  final User viewedUser;

  ProfileView({
    required this.id,
    required this.viewerId,
    required this.viewedUserId,
    required this.createdAt,
    required this.viewer,
    required this.viewedUser,
  });

  factory ProfileView.fromJson(Map<String, dynamic> json) {
    return ProfileView(
      id: json['id'] ?? 0,
      viewerId: json['viewerId'] ?? 0,
      viewedUserId: json['viewedUserId'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
      viewer: User.fromJson(json['viewer'] ?? {}),
      viewedUser: User.fromJson(json['viewedUser'] ?? {}),
    );
  }
}
