import 'package:wetieko/data/response/places/place_item_response.dart';

class AddFavoriteResponse {
  final bool isSuccess;
  final String? message;
  final AddFavoriteData? data;
  final List<String>? errors;
  final String? errorCode;

  AddFavoriteResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory AddFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return AddFavoriteResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null
          ? AddFavoriteData.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class AddFavoriteData {
  final int id;
  final int userId;
  final int placeId;
  final DateTime createdAt;
  final PlaceItemResponse place;

  AddFavoriteData({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.createdAt,
    required this.place,
  });

  factory AddFavoriteData.fromJson(Map<String, dynamic> json) {
    return AddFavoriteData(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      placeId: json["placeId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      place: PlaceItemResponse.fromJson(json["place"]),
    );
  }
}
