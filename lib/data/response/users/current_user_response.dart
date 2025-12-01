import 'package:wetieko/data/response/users/user_item_response.dart';

class CurrentUserResponse {
  final bool isSuccess;
  final String? message;
  final UserItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  CurrentUserResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) {
    return CurrentUserResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null && json['data'] is Map
          ? UserItemResponse.fromJson(json['data'])
          : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}
