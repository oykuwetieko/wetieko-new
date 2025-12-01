class MessageAccessRejectPathResponse {
  final bool isSuccess;
  final String? message;
  final bool? data; // true / false
  final List<String>? errors;
  final String? errorCode;

  MessageAccessRejectPathResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageAccessRejectPathResponse.fromJson(Map<String, dynamic> json) {
    return MessageAccessRejectPathResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"],
      errors: (json["errors"] as List?)?.map((e) => e.toString()).toList(),
      errorCode: json["errorCode"],
    );
  }
}
