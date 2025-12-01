import 'package:wetieko/data/response/places/place_item_response.dart';

class UserCheckInHistoryResponse {
  final bool isSuccess;
  final String? message;
  final List<UserCheckInHistoryItem> data;
  final List<String>? errors;
  final String? errorCode;

  UserCheckInHistoryResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory UserCheckInHistoryResponse.fromJson(Map<String, dynamic> json) {
    return UserCheckInHistoryResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => UserCheckInHistoryItem.fromJson(e))
          .toList(),
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class UserCheckInHistoryItem {
  final String placeId;
  final String placeName;
  final DateTime createdAt;
  final bool isRecentlyCheckedIn;
  final DateTime expiresAt;
  final PlaceItemResponse? place;

  UserCheckInHistoryItem({
    required this.placeId,
    required this.placeName,
    required this.createdAt,
    required this.isRecentlyCheckedIn,
    required this.expiresAt,
    required this.place,
  });

  factory UserCheckInHistoryItem.fromJson(Map<String, dynamic> json) {
    return UserCheckInHistoryItem(
      placeId: json["placeId"] ?? "",
      placeName: json["placeName"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRecentlyCheckedIn: json["isRecentlyCheckedIn"] ?? false,
      expiresAt: DateTime.tryParse(json["expiresAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      place: json["place"] != null
          ? PlaceItemResponse.fromJson(json["place"])
          : null,
    );
  }
}
