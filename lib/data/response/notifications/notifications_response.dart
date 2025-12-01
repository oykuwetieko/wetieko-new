import 'package:wetieko/data/response/notifications/notification_item_response.dart';

class NotificationsResponse {
  final bool isSuccess;
  final String? message;
  final List<NotificationItemResponse>? data;
  final List<String>? errors;
  final String? errorCode;

  NotificationsResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] is List)
          ? (json["data"] as List)
              .map((e) => NotificationItemResponse.fromJson(e))
              .toList()
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
