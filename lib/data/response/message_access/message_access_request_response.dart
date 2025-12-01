import 'package:wetieko/data/response/message_access/message_access_item_response.dart';

class MessageAccessRequestResponse {
  final bool isSuccess;
  final String? message;
  final MessageAccessItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  MessageAccessRequestResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessRequestResponse.fromJson(Map<String, dynamic> json) {
    return MessageAccessRequestResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? MessageAccessItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
