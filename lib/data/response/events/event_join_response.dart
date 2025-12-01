class EventJoinResponse {
  final bool isSuccess;
  final String? message;
  final String? data;
  final List<String>? errors;
  final String? errorCode;

  EventJoinResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory EventJoinResponse.fromJson(Map<String, dynamic> json) {
    return EventJoinResponse(
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
