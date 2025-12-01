import 'package:wetieko/data/response/places/place_item_response.dart';

class PlacesListResponse {
  final bool isSuccess;
  final String? message;
  final List<PlaceItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  PlacesListResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory PlacesListResponse.fromJson(Map<String, dynamic> json) {
    return PlacesListResponse(
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
