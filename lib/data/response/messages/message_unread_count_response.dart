import 'package:wetieko/data/response/messages/message_unread_count_item_response.dart';

class MessageUnreadCountResponse {
  final bool isSuccess;
  final String? message;
  final MessageUnreadCountItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  MessageUnreadCountResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageUnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return MessageUnreadCountResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? MessageUnreadCountItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
