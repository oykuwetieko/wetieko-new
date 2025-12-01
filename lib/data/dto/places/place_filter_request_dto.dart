class PlaceFilterRequestDto {
  final String? city;
  final int? priceLevel;

  final bool? hasMeetingArea;
  final bool? hasOutdoorArea;
  final bool? isPetFriendly;
  final bool? hasParking;
  final bool? hasView;

  final List<int>? ratings;

  final double? avgWifi;
  final double? avgSocket;
  final double? avgNoiseLevel;
  final double? avgWorkDesk;
  final double? avgVentilation;
  final double? avgLighting;

  final bool? isOpenNow;

  PlaceFilterRequestDto({
    this.city,
    this.priceLevel,
    this.hasMeetingArea,
    this.hasOutdoorArea,
    this.isPetFriendly,
    this.hasParking,
    this.hasView,
    this.ratings,
    this.avgWifi,
    this.avgSocket,
    this.avgNoiseLevel,
    this.avgWorkDesk,
    this.avgVentilation,
    this.avgLighting,
    this.isOpenNow,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "priceLevel": priceLevel,
      "hasMeetingArea": hasMeetingArea,
      "hasOutdoorArea": hasOutdoorArea,
      "isPetFriendly": isPetFriendly,
      "hasParking": hasParking,
      "hasView": hasView,
      "ratings": ratings,
      "avgWifi": avgWifi,
      "avgSocket": avgSocket,
      "avgNoiseLevel": avgNoiseLevel,
      "avgWorkDesk": avgWorkDesk,
      "avgVentilation": avgVentilation,
      "avgLighting": avgLighting,
      "isOpenNow": isOpenNow,
    };
  }
}
