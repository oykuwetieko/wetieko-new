import 'package:Wetieko/models/event_model.dart'; // EventType burada tanımlı

class CreateEventDto {
  final EventType type;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String placeId;

  // Opsiyonel alanlar
  final int? maxParticipants;
  final bool? hasSpeaker;
  final bool? hasWorkshop;
  final bool? hasCertificate;
  final bool? isFree;
  final bool? hasTreat;
  final bool? hasRaffle;
  final bool? hasGift;
  final bool? isOutdoor;
  final bool? hasSeatTable;
  final bool? hasPhotoVideo;

  CreateEventDto({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.placeId,
    this.maxParticipants,
    this.hasSpeaker,
    this.hasWorkshop,
    this.hasCertificate,
    this.isFree,
    this.hasTreat,
    this.hasRaffle,
    this.hasGift,
    this.isOutdoor,
    this.hasSeatTable,
    this.hasPhotoVideo,
  });

  Map<String, dynamic> toJson() {
  final map = {
    'type': type.name,
    'title': title,
    'description': description,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'placeId': placeId,
    if (maxParticipants != null) 'maxParticipants': maxParticipants,
    if (hasSpeaker != null) 'hasSpeaker': hasSpeaker,
    if (hasWorkshop != null) 'hasWorkshop': hasWorkshop,
    if (hasCertificate != null) 'hasCertificate': hasCertificate,
    if (isFree != null) 'isFree': isFree,
    if (hasTreat != null) 'hasTreat': hasTreat,
    if (hasRaffle != null) 'hasRaffle': hasRaffle,
    if (hasGift != null) 'hasGift': hasGift,
    if (isOutdoor != null) 'isOutdoor': isOutdoor,
    if (hasSeatTable != null) 'hasSeatTable': hasSeatTable,
    if (hasPhotoVideo != null) 'hasPhotoVideo': hasPhotoVideo,
  };

  print('🔍 FINAL JSON BODY: $map');
  return map;
}

}
