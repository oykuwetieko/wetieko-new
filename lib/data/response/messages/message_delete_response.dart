class MessageDeleteResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  MessageDeleteResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageDeleteResponse.fromJson(Map<String, dynamic> json) {
    return MessageDeleteResponse(
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
