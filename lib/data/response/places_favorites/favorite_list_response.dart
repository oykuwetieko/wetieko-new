import 'package:wetieko/data/response/places/place_item_response.dart';

class FavoriteListResponse {
  final bool isSuccess;
  final String? message;
  final List<FavoriteItemResponse> data;
  final List<String>? errors;
  final String? errorCode;

  FavoriteListResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteListResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FavoriteItemResponse.fromJson(e))
          .toList(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}

class FavoriteItemResponse {
  final int id;
  final int userId;
  final int placeId;
  final DateTime createdAt;
  final PlaceItemResponse place;

  FavoriteItemResponse({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.createdAt,
    required this.place,
  });

  factory FavoriteItemResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteItemResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      placeId: json['placeId'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      place: PlaceItemResponse.fromJson(json['place']),
    );
  }
}
