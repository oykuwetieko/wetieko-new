import 'package:wetieko/data/response/events/event_item_response.dart';

class EventUpdateResponse {
  final bool isSuccess;
  final String? message;
  final EventItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  EventUpdateResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory EventUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EventUpdateResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] != null && json["data"] is Map)
          ? EventItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
