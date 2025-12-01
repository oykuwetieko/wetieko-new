import 'package:wetieko/data/response/notifications/notification_unread_summary_item_response.dart';

class NotificationUnreadSummaryResponse {
  final bool isSuccess;
  final String? message;
  final NotificationUnreadSummaryItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  NotificationUnreadSummaryResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory NotificationUnreadSummaryResponse.fromJson(
      Map<String, dynamic> json) {
    return NotificationUnreadSummaryResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is Map<String, dynamic>
          ? NotificationUnreadSummaryItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
