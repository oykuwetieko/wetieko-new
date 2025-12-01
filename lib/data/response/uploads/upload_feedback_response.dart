class UploadFeedbackResponse {
  final bool isSuccess;
  final String? message;
  final String? data; // uploaded image URL
  final List<String>? errors;
  final String? errorCode;

  UploadFeedbackResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory UploadFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return UploadFeedbackResponse(
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
