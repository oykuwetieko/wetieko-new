class EventLeaveResponse {
  final bool isSuccess;
  final String? message;
  final String? data;
  final List<String>? errors;
  final String? errorCode;

  EventLeaveResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory EventLeaveResponse.fromJson(Map<String, dynamic> json) {
    return EventLeaveResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"]?.toString(),
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
