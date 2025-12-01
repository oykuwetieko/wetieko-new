import 'package:Wetieko/models/event_model.dart'; // Buradan EventType'ı çekiyoruz

class UpdateEventDto {
  final EventType? type;
  final String? title;
  final String? description;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? placeId;
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

  UpdateEventDto({
    this.type,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.placeId,
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

  /// ✅ JSON'dan nesne oluşturmak için factory constructor
  factory UpdateEventDto.fromJson(Map<String, dynamic> json) {
    return UpdateEventDto(
      type: json['type'] != null
          ? EventType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => EventType.ETKINLIK,
            )
          : null,
      title: json['title'],
      description: json['description'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      placeId: json['placeId'],
      maxParticipants: json['maxParticipants'],
      hasSpeaker: json['hasSpeaker'],
      hasWorkshop: json['hasWorkshop'],
      hasCertificate: json['hasCertificate'],
      isFree: json['isFree'],
      hasTreat: json['hasTreat'],
      hasRaffle: json['hasRaffle'],
      hasGift: json['hasGift'],
      isOutdoor: json['isOutdoor'],
      hasSeatTable: json['hasSeatTable'],
      hasPhotoVideo: json['hasPhotoVideo'],
    );
  }

  /// ✅ JSON’a dönüştürme metodu (API'ye gönderilirken)
  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type!.name,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (placeId != null) 'placeId': placeId,
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
  }
}
