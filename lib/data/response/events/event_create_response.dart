import 'package:wetieko/data/response/events/event_item_response.dart';

class EventCreateResponse {
  final bool isSuccess;
  final String? message;
  final EventItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  EventCreateResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory EventCreateResponse.fromJson(Map<String, dynamic> json) {
    return EventCreateResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null
          ? EventItemResponse.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
