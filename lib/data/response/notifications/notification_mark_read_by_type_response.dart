class NotificationMarkReadByTypeResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  NotificationMarkReadByTypeResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory NotificationMarkReadByTypeResponse.fromJson(
      Map<String, dynamic> json) {
    return NotificationMarkReadByTypeResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is bool ? json["data"] : null,
      errors: (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
