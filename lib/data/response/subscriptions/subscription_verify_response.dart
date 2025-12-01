class SubscriptionVerifyResponse {
  final bool isSuccess;
  final String? message;
  final SubscriptionData? data;
  final List<String>? errors;
  final String? errorCode;

  SubscriptionVerifyResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory SubscriptionVerifyResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionVerifyResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data:
          json["data"] != null ? SubscriptionData.fromJson(json["data"]) : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class SubscriptionData {
  final int id;
  final int userId;
  final String plan;
  final String platform;
  final String providerProductId;
  final String providerPurchaseToken;
  final String status;

  final DateTime? startedAt;
  final DateTime? expiresAt;
  final DateTime? canceledAt;
  final bool isAutoRenew;
  final DateTime? lastVerificationAt;
  final DateTime? createdAt;

  SubscriptionData({
    required this.id,
    required this.userId,
    required this.plan,
    required this.platform,
    required this.providerProductId,
    required this.providerPurchaseToken,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    required this.canceledAt,
    required this.isAutoRenew,
    required this.lastVerificationAt,
    required this.createdAt,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      plan: json["plan"] ?? "",
      platform: json["platform"] ?? "",
      providerProductId: json["providerProductId"] ?? "",
      providerPurchaseToken: json["providerPurchaseToken"] ?? "",
      status: json["status"] ?? "",
      startedAt: DateTime.tryParse(json["startedAt"] ?? ""),
      expiresAt: DateTime.tryParse(json["expiresAt"] ?? ""),
      canceledAt: DateTime.tryParse(json["canceledAt"] ?? ""),
      isAutoRenew: json["isAutoRenew"] ?? false,
      lastVerificationAt: DateTime.tryParse(json["lastVerificationAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }
}
