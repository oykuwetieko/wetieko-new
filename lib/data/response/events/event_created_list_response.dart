import 'package:wetieko/data/response/events/event_item_response.dart';

class EventCreatedListResponse {
  final bool isSuccess;
  final String? message;
  final List<EventItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  EventCreatedListResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory EventCreatedListResponse.fromJson(Map<String, dynamic> json) {
    return EventCreatedListResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => EventItemResponse.fromJson(e))
          .toList(),
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
