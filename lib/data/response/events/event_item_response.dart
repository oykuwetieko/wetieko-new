import 'package:wetieko/data/response/places/place_item_response.dart';

class EventItemResponse {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String type;
  final int maxParticipants;
  final DateTime createdAt;

  final bool hasSpeaker;
  final bool hasWorkshop;
  final bool isFree;
  final bool hasGift;
  final bool isOutdoor;
  final bool hasPhotoVideo;
  final bool hasCertificate;
  final bool hasRaffle;
  final bool hasSeatTable;
  final bool hasTreat;

  final EventCreator creator;
  final PlaceItemResponse place;
  final List<EventParticipant> participants;

  EventItemResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.maxParticipants,
    required this.createdAt,
    required this.hasSpeaker,
    required this.hasWorkshop,
    required this.isFree,
    required this.hasGift,
    required this.isOutdoor,
    required this.hasPhotoVideo,
    required this.hasCertificate,
    required this.hasRaffle,
    required this.hasSeatTable,
    required this.hasTreat,
    required this.creator,
    required this.place,
    required this.participants,
  });

  factory EventItemResponse.fromJson(Map<String, dynamic> json) {
    return EventItemResponse(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: DateTime.tryParse(json["date"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      type: json["type"] ?? "",
      maxParticipants: json["maxParticipants"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),

      hasSpeaker: json["hasSpeaker"] ?? false,
      hasWorkshop: json["hasWorkshop"] ?? false,
      isFree: json["isFree"] ?? false,
      hasGift: json["hasGift"] ?? false,
      isOutdoor: json["isOutdoor"] ?? false,
      hasPhotoVideo: json["hasPhotoVideo"] ?? false,
      hasCertificate: json["hasCertificate"] ?? false,
      hasRaffle: json["hasRaffle"] ?? false,
      hasSeatTable: json["hasSeatTable"] ?? false,
      hasTreat: json["hasTreat"] ?? false,

      creator: EventCreator.fromJson(json["creator"]),
      place: PlaceItemResponse.fromJson(json["place"]),
      participants: (json["participants"] as List<dynamic>? ?? [])
          .map((e) => EventParticipant.fromJson(e))
          .toList(),
    );
  }
}

class EventCreator {
  final int id;
  final String fullName;
  final String gender;
  final DateTime? birthDate;

  final List<String> industry;
  final List<String> careerPosition;
  final List<String> careerStage;

  EventCreator({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.industry,
    required this.careerPosition,
    required this.careerStage,
  });

  factory EventCreator.fromJson(Map<String, dynamic> json) {
    return EventCreator(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "",
      gender: json["gender"] ?? "",
      birthDate: json["birthDate"] != null
          ? DateTime.tryParse(json["birthDate"])
          : null,
      industry: (json["industry"] as List<dynamic>? ?? []).cast<String>(),
      careerPosition:
          (json["careerPosition"] as List<dynamic>? ?? []).cast<String>(),
      careerStage:
          (json["careerStage"] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

class EventParticipant {
  final int id;
  final String fullName;
  final String gender;
  final DateTime? birthDate;

  final List<String> industry;
  final List<String> careerPosition;
  final List<String> careerStage;

  EventParticipant({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.industry,
    required this.careerPosition,
    required this.careerStage,
  });

  factory EventParticipant.fromJson(Map<String, dynamic> json) {
    return EventParticipant(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "",
      gender: json["gender"] ?? "",
      birthDate: json["birthDate"] != null
          ? DateTime.tryParse(json["birthDate"])
          : null,
      industry: (json["industry"] as List<dynamic>? ?? []).cast<String>(),
      careerPosition:
          (json["careerPosition"] as List<dynamic>? ?? []).cast<String>(),
      careerStage:
          (json["careerStage"] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
