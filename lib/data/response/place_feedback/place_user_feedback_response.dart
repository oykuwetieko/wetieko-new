import 'package:wetieko/data/response/users/user_item_response.dart';
import 'package:wetieko/data/response/places/place_item_response.dart';

class PlaceUserFeedbackResponse {
  final bool isSuccess;
  final String? message;
  final PlaceUserFeedbackData? data;
  final List<String>? errors;
  final String? errorCode;

  PlaceUserFeedbackResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceUserFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return PlaceUserFeedbackResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? PlaceUserFeedbackData.fromJson(json['data'])
          : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}

class PlaceUserFeedbackData {
  final int totalPlacesCommented;
  final List<PlaceUserFeedbackItem> feedbacks;

  PlaceUserFeedbackData({
    required this.totalPlacesCommented,
    required this.feedbacks,
  });

  factory PlaceUserFeedbackData.fromJson(Map<String, dynamic> json) {
    return PlaceUserFeedbackData(
      totalPlacesCommented: json['totalPlacesCommented'] ?? 0,
      feedbacks: (json['feedbacks'] as List<dynamic>? ?? [])
          .map((e) => PlaceUserFeedbackItem.fromJson(e))
          .toList(),
    );
  }
}

class PlaceUserFeedbackItem {
  final int id;
  final int userId;
  final int placeDbId;

  final int wifi;
  final int socket;
  final int noiseLevel;
  final int workDesk;
  final int ventilation;
  final int lighting;

  final bool hasMeetingArea;
  final bool hasOutdoorArea;
  final bool isPetFriendly;
  final bool hasParking;
  final bool hasView;

  final String? comment;
  final String? photoUrl;
  final DateTime createdAt;

  final UserItemResponse user;
  final PlaceItemResponse place;

  PlaceUserFeedbackItem({
    required this.id,
    required this.userId,
    required this.placeDbId,
    required this.wifi,
    required this.socket,
    required this.noiseLevel,
    required this.workDesk,
    required this.ventilation,
    required this.lighting,
    required this.hasMeetingArea,
    required this.hasOutdoorArea,
    required this.isPetFriendly,
    required this.hasParking,
    required this.hasView,
    required this.comment,
    required this.photoUrl,
    required this.createdAt,
    required this.user,
    required this.place,
  });

  factory PlaceUserFeedbackItem.fromJson(Map<String, dynamic> json) {
    return PlaceUserFeedbackItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      placeDbId: json['placeDbId'] ?? 0,
      wifi: json['wifi'] ?? 0,
      socket: json['socket'] ?? 0,
      noiseLevel: json['noiseLevel'] ?? 0,
      workDesk: json['workDesk'] ?? 0,
      ventilation: json['ventilation'] ?? 0,
      lighting: json['lighting'] ?? 0,
      hasMeetingArea: json['hasMeetingArea'] ?? false,
      hasOutdoorArea: json['hasOutdoorArea'] ?? false,
      isPetFriendly: json['isPetFriendly'] ?? false,
      hasParking: json['hasParking'] ?? false,
      hasView: json['hasView'] ?? false,
      comment: json['comment'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      user: UserItemResponse.fromJson(json['user']),
      place: PlaceItemResponse.fromJson(json['place']),
    );
  }
}
