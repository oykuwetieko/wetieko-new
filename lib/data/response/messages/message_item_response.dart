import 'package:wetieko/data/response/users/user_item_response.dart';

class MessageItemResponse {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final bool isRead;
  final bool pending;
  final bool senderDeleted;
  final bool receiverDeleted;
  final DateTime createdAt;

  final UserItemResponse? sender;
  final UserItemResponse? receiver;

  MessageItemResponse({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isRead,
    required this.pending,
    required this.senderDeleted,
    required this.receiverDeleted,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory MessageItemResponse.fromJson(Map<String, dynamic> json) {
    return MessageItemResponse(
      id: json["id"] ?? 0,
      senderId: json["senderId"] ?? 0,
      receiverId: json["receiverId"] ?? 0,
      content: json["content"] ?? "",
      isRead: json["isRead"] ?? false,
      pending: json["pending"] ?? false,
      senderDeleted: json["senderDeleted"] ?? false,
      receiverDeleted: json["receiverDeleted"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      sender: json["sender"] is Map<String, dynamic>
          ? UserItemResponse.fromJson(json["sender"])
          : null,
      receiver: json["receiver"] is Map<String, dynamic>
          ? UserItemResponse.fromJson(json["receiver"])
          : null,
    );
  }
}
