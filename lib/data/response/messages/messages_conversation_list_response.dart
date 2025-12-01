import 'package:wetieko/data/response/messages/message_item_response.dart';

class MessagesConversationListResponse {
  final bool isSuccess;
  final String? message;
  final List<MessageItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  MessagesConversationListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessagesConversationListResponse.fromJson(Map<String, dynamic> json) {
    return MessagesConversationListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is List)
          ? (json["data"] as List)
              .map((e) => MessageItemResponse.fromJson(e))
              .toList()
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
