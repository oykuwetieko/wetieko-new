class PlaceFeedbackResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  PlaceFeedbackResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return PlaceFeedbackResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is bool ? json["data"] : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
