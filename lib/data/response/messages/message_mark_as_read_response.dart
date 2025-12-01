class MessageMarkAsReadResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  MessageMarkAsReadResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory MessageMarkAsReadResponse.fromJson(Map<String, dynamic> json) {
    return MessageMarkAsReadResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] == true,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
