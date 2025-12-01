import 'package:wetieko/data/response/users/user_item_response.dart';

class UsersResponse {
  final bool isSuccess;
  final String? message;
  final List<UserItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  UsersResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => UserItemResponse.fromJson(e))
          .toList(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}
