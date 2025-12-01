class PlaceItemResponse {
  final int id;
  final String placeId;
  final String name;
  final String formattedAddress;
  final double lat;
  final double lng;
  final String city;
  final String district;
  final double rating;
  final int priceLevel;
  final List<String> weekdayText;
  final List<String> photoReferences;

  final double avgLighting;
  final double avgNoiseLevel;
  final double avgSocket;
  final double avgVentilation;
  final double avgWifi;
  final double avgWorkDesk;

  final bool hasMeetingArea;
  final bool hasOutdoorArea;
  final bool hasParking;
  final bool hasView;
  final bool isPetFriendly;

  final PlaceFeedbackSummary? feedbackSummary;
  final List<PlaceCheckIn> checkIns;
  final List<PlaceAttendee> attendees;

  final DateTime? createdAt;
  final String? message;

  PlaceItemResponse({
    required this.id,
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    required this.city,
    required this.district,
    required this.rating,
    required this.priceLevel,
    required this.weekdayText,
    required this.photoReferences,
    required this.avgLighting,
    required this.avgNoiseLevel,
    required this.avgSocket,
    required this.avgVentilation,
    required this.avgWifi,
    required this.avgWorkDesk,
    required this.hasMeetingArea,
    required this.hasOutdoorArea,
    required this.hasParking,
    required this.hasView,
    required this.isPetFriendly,
    required this.feedbackSummary,
    required this.checkIns,
    required this.attendees,
    required this.createdAt,
    required this.message,
  });

  factory PlaceItemResponse.fromJson(Map<String, dynamic> json) {
    return PlaceItemResponse(
      id: json['id'] ?? 0,
      placeId: json['placeId'] ?? '',
      name: json['name'] ?? '',
      formattedAddress: json['formattedAddress'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      priceLevel: json['priceLevel'] ?? 0,
      weekdayText: (json['weekdayText'] as List<dynamic>? ?? []).cast<String>(),
      photoReferences:
          (json['photoReferences'] as List<dynamic>? ?? []).cast<String>(),

      avgLighting: (json['avgLighting'] ?? 0).toDouble(),
      avgNoiseLevel: (json['avgNoiseLevel'] ?? 0).toDouble(),
      avgSocket: (json['avgSocket'] ?? 0).toDouble(),
      avgVentilation: (json['avgVentilation'] ?? 0).toDouble(),
      avgWifi: (json['avgWifi'] ?? 0).toDouble(),
      avgWorkDesk: (json['avgWorkDesk'] ?? 0).toDouble(),

      hasMeetingArea: json['hasMeetingArea'] ?? false,
      hasOutdoorArea: json['hasOutdoorArea'] ?? false,
      hasParking: json['hasParking'] ?? false,
      hasView: json['hasView'] ?? false,
      isPetFriendly: json['isPetFriendly'] ?? false,

      feedbackSummary: json['feedbackSummary'] != null
          ? PlaceFeedbackSummary.fromJson(json['feedbackSummary'])
          : null,

      checkIns: (json['checkIns'] as List<dynamic>? ?? [])
          .map((e) => PlaceCheckIn.fromJson(e))
          .toList(),

      attendees: (json['attendees'] as List<dynamic>? ?? [])
          .map((e) => PlaceAttendee.fromJson(e))
          .toList(),

      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      message: json['message'],
    );
  }
}

//
// -------------------------------------------------------------
// FEEDBACK SUMMARY MODELS
// -------------------------------------------------------------

class PlaceFeedbackSummary {
  final int total;
  final PlaceFeedbackAverage avg;
  final PlaceFeedbackFeatures features;
  final List<PlaceFeedbackComment> comments;

  PlaceFeedbackSummary({
    required this.total,
    required this.avg,
    required this.features,
    required this.comments,
  });

  factory PlaceFeedbackSummary.fromJson(Map<String, dynamic> json) {
    return PlaceFeedbackSummary(
      total: json['total'] ?? 0,
      avg: PlaceFeedbackAverage.fromJson(json['avg'] ?? {}),
      features: PlaceFeedbackFeatures.fromJson(json['features'] ?? {}),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => PlaceFeedbackComment.fromJson(e))
          .toList(),
    );
  }
}

class PlaceFeedbackAverage {
  final double wifi;
  final double socket;
  final double noise;
  final double desk;
  final double ventilation;
  final double lighting;

  PlaceFeedbackAverage({
    required this.wifi,
    required this.socket,
    required this.noise,
    required this.desk,
    required this.ventilation,
    required this.lighting,
  });

  factory PlaceFeedbackAverage.fromJson(Map<String, dynamic> json) {
    return PlaceFeedbackAverage(
      wifi: (json['wifi'] ?? 0).toDouble(),
      socket: (json['socket'] ?? 0).toDouble(),
      noise: (json['noise'] ?? 0).toDouble(),
      desk: (json['desk'] ?? 0).toDouble(),
      ventilation: (json['ventilation'] ?? 0).toDouble(),
      lighting: (json['lighting'] ?? 0).toDouble(),
    );
  }
}

class PlaceFeedbackFeatures {
  final bool meetingFriendly;
  final bool openArea;
  final bool petFriendly;
  final bool hasParking;
  final bool hasView;
  final bool hasMeetingArea;
  final bool hasOutdoorArea;
  final bool isPetFriendly;

  PlaceFeedbackFeatures({
    required this.meetingFriendly,
    required this.openArea,
    required this.petFriendly,
    required this.hasParking,
    required this.hasView,
    required this.hasMeetingArea,
    required this.hasOutdoorArea,
    required this.isPetFriendly,
  });

  factory PlaceFeedbackFeatures.fromJson(Map<String, dynamic> json) {
    return PlaceFeedbackFeatures(
      meetingFriendly: json['meetingFriendly'] ?? false,
      openArea: json['openArea'] ?? false,
      petFriendly: json['petFriendly'] ?? false,
      hasParking: json['hasParking'] ?? false,
      hasView: json['hasView'] ?? false,
      hasMeetingArea: json['hasMeetingArea'] ?? false,
      hasOutdoorArea: json['hasOutdoorArea'] ?? false,
      isPetFriendly: json['isPetFriendly'] ?? false,
    );
  }
}

class PlaceFeedbackComment {
  final int userId;
  final String comment;

  PlaceFeedbackComment({
    required this.userId,
    required this.comment,
  });

  factory PlaceFeedbackComment.fromJson(Map<String, dynamic> json) {
    return PlaceFeedbackComment(
      userId: json['userId'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
}

//
// -------------------------------------------------------------
// CHECK-IN MODELS
// -------------------------------------------------------------

class PlaceCheckIn {
  final int id;
  final int placeDbId;
  final int userId;
  final String comment;
  final DateTime createdAt;
  final bool isRecentlyCheckedIn;
  final DateTime expiresAt;
  final DateTime updatedAt;
  final String? place;

  PlaceCheckIn({
    required this.id,
    required this.placeDbId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.isRecentlyCheckedIn,
    required this.expiresAt,
    required this.updatedAt,
    this.place,
  });

  factory PlaceCheckIn.fromJson(Map<String, dynamic> json) {
    return PlaceCheckIn(
      id: json['id'] ?? 0,
      placeDbId: json['placeDbId'] ?? 0,
      userId: json['userId'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isRecentlyCheckedIn: json['isRecentlyCheckedIn'] ?? false,
      expiresAt:
          DateTime.tryParse(json['expiresAt'] ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      place: json['place'],
    );
  }
}

//
// -------------------------------------------------------------
// ATTENDEE MODELS
// -------------------------------------------------------------

class PlaceAttendee {
  final int userId;
  final String name;
  final String profileImage;
  final String careerPosition;
  final DateTime checkInAt;

  PlaceAttendee({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.careerPosition,
    required this.checkInAt,
  });

  factory PlaceAttendee.fromJson(Map<String, dynamic> json) {
    return PlaceAttendee(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      careerPosition: json['careerPosition'] ?? '',
      checkInAt: DateTime.tryParse(json['checkInAt'] ?? '') ?? DateTime.now(),
    );
  }
}
