import 'package:Wetieko/models/user_model.dart';

class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime createdAt;
  final User sender;
  final User receiver;
  final bool pending;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    required this.sender,
    required this.receiver,
    this.pending = false,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? 0,
      receiverId: json['receiverId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '')?.toLocal()
          ?? DateTime.now(),

      // User parse
      sender: json['sender'] != null
          ? User.fromJson(json['sender'])
          : User.empty(),
      receiver: json['receiver'] != null
          ? User.fromJson(json['receiver'])
          : User.empty(),

      // Pending field fallback
      pending: json['pending'] 
            ?? json['isPending'] 
            ?? (json['status'] == 'pending')
            ?? false,

      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'pending': pending,
      'isRead': isRead,
    };
  }

  MessageModel copyWith({
    bool? isRead,
    bool? pending,
  }) {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      createdAt: createdAt,
      sender: sender,
      receiver: receiver,
      pending: pending ?? this.pending,
      isRead: isRead ?? this.isRead,
    );
  }
}
