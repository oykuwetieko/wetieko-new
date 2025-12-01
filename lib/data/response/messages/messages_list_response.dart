import 'package:wetieko/data/response/messages/message_item_response.dart';

class MessagesListResponse {
  final bool isSuccess;
  final String? message;
  final List<MessageItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  MessagesListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessagesListResponse.fromJson(Map<String, dynamic> json) {
    return MessagesListResponse(
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
