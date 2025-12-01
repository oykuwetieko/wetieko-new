class FcmTokenItemResponse {
  final int id;
  final int userId;
  final String token;
  final DateTime createdAt;

  FcmTokenItemResponse({
    required this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
  });

  factory FcmTokenItemResponse.fromJson(Map<String, dynamic> json) {
    return FcmTokenItemResponse(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      token: json["token"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
