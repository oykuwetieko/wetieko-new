import 'package:wetieko/data/response/message_access/message_access_item_response.dart';

class MessageAccessIncomingListResponse {
  final bool isSuccess;
  final String? message;
  final List<MessageAccessItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  MessageAccessIncomingListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessIncomingListResponse.fromJson(
      Map<String, dynamic> json) {
    return MessageAccessIncomingListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is List)
          ? (json["data"] as List)
              .map((e) => MessageAccessItemResponse.fromJson(e))
              .toList()
          : null,
      errors: (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
