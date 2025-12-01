// lib/models/filter_event_dto.dart
class FilterEventDto {
  // Tekil şehir (geri uyumluluk için)
  final String? city;

  // Çoklu şehir
  final List<String>? cities;

  // Sadece gün seç
  final DateTime? date;

  // Kapasite kovası (0/5/10/15/20)
  final int? participantCount;

  // Activity için OR mantığında gönderilecek özellik isimleri
  final List<String>? eventFeatures;

  // Geri uyumluluk: tekil bayraklar (opsiyonel)
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

  FilterEventDto({
    this.city,
    this.cities,
    this.date,
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
  });

  Map<String, dynamic> toJson() {
    final bool hasCities = cities != null && cities!.isNotEmpty;

    return {
      // Çoklu şehir varsa onu gönder; yoksa tekil city’yi gönder
      if (hasCities) 'cities': cities,
      if (!hasCities && city != null) 'city': city,

      if (date != null)
        'date': DateTime.utc(date!.year, date!.month, date!.day).toIso8601String(),

      if (participantCount != null) 'participantCount': participantCount,

      if (eventFeatures != null && eventFeatures!.isNotEmpty)
        'eventFeatures': eventFeatures,

      // Tekil bayraklar (geri uyumluluk)
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
