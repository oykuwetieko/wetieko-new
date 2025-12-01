class MessageAccessHasResponse {
  final bool isSuccess;
  final String? message;
  final bool? data; // true / false
  final List<String>? errors;
  final String? errorCode;

  MessageAccessHasResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessHasResponse.fromJson(Map<String, dynamic> json) {
    return MessageAccessHasResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] is bool ? json["data"] : null,
      errors: (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
