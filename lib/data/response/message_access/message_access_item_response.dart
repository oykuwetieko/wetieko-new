import 'package:wetieko/data/response/users/user_item_response.dart';

class MessageAccessItemResponse {
  final int id;
  final int requesterId;
  final int receiverId;
  final String status;
  final DateTime createdAt;

  final UserItemResponse? requester;
  final UserItemResponse? receiver;

  MessageAccessItemResponse({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    this.requester,
    this.receiver,
  });

  factory MessageAccessItemResponse.fromJson(Map<String, dynamic> json) {
    return MessageAccessItemResponse(
      id: json["id"] ?? 0,
      requesterId: json["requesterId"] ?? 0,
      receiverId: json["receiverId"] ?? 0,
      status: json["status"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      requester: json["requester"] is Map<String, dynamic>
          ? UserItemResponse.fromJson(json["requester"])
          : null,
      receiver: json["receiver"] is Map<String, dynamic>
          ? UserItemResponse.fromJson(json["receiver"])
          : null,
    );
  }
}
