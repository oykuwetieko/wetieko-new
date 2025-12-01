import 'package:wetieko/data/response/subscriptions/subscription_verify_response.dart';

class SubscriptionMeResponse {
  final bool isSuccess;
  final String? message;
  final SubscriptionData? data;
  final List<String>? errors;
  final String? errorCode;

  SubscriptionMeResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory SubscriptionMeResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionMeResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null
          ? SubscriptionData.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}
