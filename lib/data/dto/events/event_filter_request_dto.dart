class EventFilterRequestDto {
  final String? type;
  final String? date;
  final String? city;
  final List<String>? cities;
  final int? participantCount;
  final List<String>? eventFeatures;

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

  final int? page;
  final int? pageSize;
  final String? orderBy;

  EventFilterRequestDto({
    this.type,
    this.date,
    this.city,
    this.cities,
    this.participantCount,
    this.eventFeatures,
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
    this.page,
    this.pageSize,
    this.orderBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "date": date,
      "city": city,
      "cities": cities,
      "participantCount": participantCount,
      "eventFeatures": eventFeatures,
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
      "page": page,
      "pageSize": pageSize,
      "orderBy": orderBy,
    };
  }
}
