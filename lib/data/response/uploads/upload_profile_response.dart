class UploadProfileResponse {
  final bool isSuccess;
  final String? message;
  final String? data; // uploaded image URL or file path
  final List<String>? errors;
  final String? errorCode;

  UploadProfileResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory UploadProfileResponse.fromJson(Map<String, dynamic> json) {
    return UploadProfileResponse(
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
