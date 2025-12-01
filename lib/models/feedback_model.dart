import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/models/place_model.dart';

class FeedbackDto {
  final int placeDbId; // 🔥 DB INT
  final double? wifiScore;
  final double? socketScore;
  final double? noiseScore;
  final double? deskScore;
  final double? ventilationScore;
  final double? lightingScore;
  final bool? meetingFriendly;
  final bool? openArea;
  final bool? petFriendly;
  final bool? hasParking;
  final bool? hasView;
  final String? comment;
  final String? photoUrl;

  FeedbackDto({
    required this.placeDbId,
    this.wifiScore,
    this.socketScore,
    this.noiseScore,
    this.deskScore,
    this.ventilationScore,
    this.lightingScore,
    this.meetingFriendly,
    this.openArea,
    this.petFriendly,
    this.hasParking,
    this.hasView,
    this.comment,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeDbId': placeDbId,
      if (wifiScore != null) 'wifiScore': wifiScore,
      if (socketScore != null) 'socketScore': socketScore,
      if (noiseScore != null) 'noiseScore': noiseScore,
      if (deskScore != null) 'deskScore': deskScore,
      if (ventilationScore != null) 'ventilationScore': ventilationScore,
      if (lightingScore != null) 'lightingScore': lightingScore,
      if (meetingFriendly != null) 'meetingFriendly': meetingFriendly,
      if (openArea != null) 'openArea': openArea,
      if (petFriendly != null) 'petFriendly': petFriendly,
      if (hasParking != null) 'hasParking': hasParking,
      if (hasView != null) 'hasView': hasView,
      if (comment != null) 'comment': comment,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}

class PlaceFeedback {
  final int id;
  final int placeDbId; // 🔥 backend int
  final int userId;
  final double wifi;
  final double socket;
  final double noiseLevel;
  final double workDesk;
  final double ventilation;
  final double lighting;
  final bool hasMeetingArea;
  final bool hasOutdoorArea;
  final bool isPetFriendly;
  final bool hasParking;
  final bool hasView;
  final String? comment;
  final String? photoUrl;
  final DateTime createdAt;

  final String? userName;
  final String? userProfileImage;
  final String? userCareerPosition;

  final String? placeName;
  final String? placeAddress;

  final Place? place;
  final User? user;

  PlaceFeedback({
    required this.id,
    required this.placeDbId,
    required this.userId,
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
    this.comment,
    this.photoUrl,
    required this.createdAt,
    this.userName,
    this.userProfileImage,
    this.userCareerPosition,
    this.placeName,
    this.placeAddress,
    this.place,
    this.user,
  });

  factory PlaceFeedback.fromJson(Map<String, dynamic> json) {
    return PlaceFeedback(
      id: json['id'],
      placeDbId: json['placeDbId'], // 🔥 int olarak alıyoruz
      userId: json['userId'],
      wifi: (json['wifi'] as num?)?.toDouble() ?? 0.0,
      socket: (json['socket'] as num?)?.toDouble() ?? 0.0,
      noiseLevel: (json['noiseLevel'] as num?)?.toDouble() ?? 0.0,
      workDesk: (json['workDesk'] as num?)?.toDouble() ?? 0.0,
      ventilation: (json['ventilation'] as num?)?.toDouble() ?? 0.0,
      lighting: (json['lighting'] as num?)?.toDouble() ?? 0.0,
      hasMeetingArea: json['hasMeetingArea'] == true,
      hasOutdoorArea: json['hasOutdoorArea'] == true,
      isPetFriendly: json['isPetFriendly'] == true,
      hasParking: json['hasParking'] == true,
      hasView: json['hasView'] == true,
      comment: json['comment'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),

      userName: json['user']?['name'],
      userProfileImage: json['user']?['profileImage'],
      userCareerPosition: json['user']?['careerPosition'],

      placeName: json['place']?['name'],
      placeAddress: json['place']?['formattedAddress'],

      place: json['place'] != null ? Place.fromJson(json['place']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
