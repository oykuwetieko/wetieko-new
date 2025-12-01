import 'package:Wetieko/models/user_model.dart';

class FollowModel {
  final String id;
  final User follower;
  final User? following;   // 🔥 NULL GELDİĞİ İÇİN ZORUNLU OLARAK nullable YAPILDI
  final String status;
  final DateTime? createdAt;

  FollowModel({
    required this.id,
    required this.follower,
    required this.following,
    required this.status,
    this.createdAt,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id']?.toString() ?? "",
      follower: User.fromJson(json['follower'] ?? {}),

      // 🔥 Backend bazen "following": null gönderiyor
      following: json['following'] != null
          ? User.fromJson(json['following'])
          : null,

      status: json['status']?.toString() ?? "",
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
