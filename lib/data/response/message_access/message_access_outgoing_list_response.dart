import 'package:wetieko/data/response/message_access/message_access_item_response.dart';

class MessageAccessOutgoingListResponse {
  final bool isSuccess;
  final String? message;
  final List<MessageAccessItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  MessageAccessOutgoingListResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessOutgoingListResponse.fromJson(
      Map<String, dynamic> json) {
    return MessageAccessOutgoingListResponse(
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
