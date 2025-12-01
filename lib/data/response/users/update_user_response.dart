import 'package:wetieko/data/response/users/user_item_response.dart';

class UpdateUserResponse {
  final bool isSuccess;
  final String? message;
  final UserItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  UpdateUserResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
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