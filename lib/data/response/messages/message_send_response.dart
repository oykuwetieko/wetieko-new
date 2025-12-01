import 'package:wetieko/data/response/messages/message_item_response.dart';

class MessageSendResponse {
  final bool isSuccess;
  final String? message;
  final MessageItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  MessageSendResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageSendResponse.fromJson(Map<String, dynamic> json) {
    return MessageSendResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? MessageItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
