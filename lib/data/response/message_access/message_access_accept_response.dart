import 'package:wetieko/data/response/message_access/message_access_accept_item_response.dart';

class MessageAccessAcceptResponse {
  final bool isSuccess;
  final String? message;
  final MessageAccessAcceptItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  MessageAccessAcceptResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessAcceptResponse.fromJson(Map<String, dynamic> json) {
    return MessageAccessAcceptResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? MessageAccessAcceptItemResponse.fromJson(json["data"])
          : null,
      errors:
          (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
