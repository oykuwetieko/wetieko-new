class RestrictionBlockResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  RestrictionBlockResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory RestrictionBlockResponse.fromJson(Map<String, dynamic> json) {
    final raw = json["data"];

    return RestrictionBlockResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: raw is bool ? raw : null, // string dönerse null olur, crash olmaz
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
