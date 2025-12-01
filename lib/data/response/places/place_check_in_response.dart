class PlaceCheckInResponse {
  final bool isSuccess;
  final String? message;
  final PlaceCheckInData? data;
  final List<String>? errors;
  final String? errorCode;

  PlaceCheckInResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceCheckInResponse.fromJson(Map<String, dynamic> json) {
    return PlaceCheckInResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null
          ? PlaceCheckInData.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class PlaceCheckInData {
  final int id;
  final int placeDbId;
  final int userId;
  final String? comment;
  final DateTime createdAt;
  final bool isRecentlyCheckedIn;
  final DateTime expiresAt;
  final DateTime updatedAt;
  final String place;

  PlaceCheckInData({
    required this.id,
    required this.placeDbId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.isRecentlyCheckedIn,
    required this.expiresAt,
    required this.updatedAt,
    required this.place,
  });

  factory PlaceCheckInData.fromJson(Map<String, dynamic> json) {
    return PlaceCheckInData(
      id: json["id"] ?? 0,
      placeDbId: json["placeDbId"] ?? 0,
      userId: json["userId"] ?? 0,
      comment: json["comment"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRecentlyCheckedIn: json["isRecentlyCheckedIn"] ?? false,
      expiresAt: DateTime.tryParse(json["expiresAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      place: json["place"] ?? "",
    );
  }
}
