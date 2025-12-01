import 'package:wetieko/data/response/places/place_item_response.dart';

class PlaceFilterListResponse {
  final bool isSuccess;
  final String? message;
  final List<PlaceItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  PlaceFilterListResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceFilterListResponse.fromJson(Map<String, dynamic> json) {
    return PlaceFilterListResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PlaceItemResponse.fromJson(e))
          .toList(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}
