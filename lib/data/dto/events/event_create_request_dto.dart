class EventCreateRequestDto {
  final int id;
  final int userId;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String type;
  final int maxParticipants;
  final int placeId;

  final bool hasSpeaker;
  final bool hasWorkshop;
  final bool hasCertificate;
  final bool isFree;
  final bool hasTreat;
  final bool hasRaffle;
  final bool hasGift;
  final bool isOutdoor;
  final bool hasSeatTable;
  final bool hasPhotoVideo;

  EventCreateRequestDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.maxParticipants,
    required this.placeId,
    required this.hasSpeaker,
    required this.hasWorkshop,
    required this.hasCertificate,
    required this.isFree,
    required this.hasTreat,
    required this.hasRaffle,
    required this.hasGift,
    required this.isOutdoor,
    required this.hasSeatTable,
    required this.hasPhotoVideo,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "startTime": startTime,
      "endTime": endTime,
      "type": type,
      "maxParticipants": maxParticipants,
      "placeId": placeId,
      "hasSpeaker": hasSpeaker,
      "hasWorkshop": hasWorkshop,
      "hasCertificate": hasCertificate,
      "isFree": isFree,
      "hasTreat": hasTreat,
      "hasRaffle": hasRaffle,
      "hasGift": hasGift,
      "isOutdoor": isOutdoor,
      "hasSeatTable": hasSeatTable,
      "hasPhotoVideo": hasPhotoVideo,
    };
  }
}
