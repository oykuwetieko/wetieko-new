import 'package:wetieko/data/response/places/place_item_response.dart';

class PlaceDetailsResponse {
  final bool isSuccess;
  final String? message;
  final PlaceItemResponse? data;
  final List<String>? errors;
  final String? errorCode;

  PlaceDetailsResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? PlaceItemResponse.fromJson(json['data'])
          : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}
