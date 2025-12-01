import 'package:wetieko/data/response/users/user_item_response.dart';

class NotificationItemResponse {
  final int id;
  final int userId;
  final int senderId;
  final String title;
  final String body;
  final String type;
  final String data;
  final bool isRead;
  final DateTime createdAt;
  final UserItemResponse? user;
  final UserItemResponse? sender;

  NotificationItemResponse({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
    this.user,
    this.sender,
  });

  factory NotificationItemResponse.fromJson(Map<String, dynamic> json) {
    return NotificationItemResponse(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      senderId: json["senderId"] ?? 0,
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "",
      data: json["data"] ?? "",
      isRead: json["isRead"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      user: json["user"] is Map
          ? UserItemResponse.fromJson(json["user"])
          : null,
      sender: json["sender"] is Map
          ? UserItemResponse.fromJson(json["sender"])
          : null,
    );
  }
}
