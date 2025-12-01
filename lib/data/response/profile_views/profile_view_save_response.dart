class ProfileViewSaveResponse {
  final bool isSuccess;
  final String? message;
  final bool? data;
  final List<String>? errors;
  final String? errorCode;

  ProfileViewSaveResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory ProfileViewSaveResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];

    return ProfileViewSaveResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: rawData is bool ? rawData : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
