class PlaceFeedbackRequestDto {
  final int placeDbId;

  final int wifiScore;
  final int socketScore;
  final int noiseScore;
  final int deskScore;
  final int ventilationScore;
  final int lightingScore;

  final bool meetingFriendly;
  final bool openArea;
  final bool petFriendly;
  final bool hasParking;
  final bool hasView;

  final String? comment;
  final String? photoUrl;

  PlaceFeedbackRequestDto({
    required this.placeDbId,
    required this.wifiScore,
    required this.socketScore,
    required this.noiseScore,
    required this.deskScore,
    required this.ventilationScore,
    required this.lightingScore,
    required this.meetingFriendly,
    required this.openArea,
    required this.petFriendly,
    required this.hasParking,
    required this.hasView,
    this.comment,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "placeDbId": placeDbId,
      "wifiScore": wifiScore,
      "socketScore": socketScore,
      "noiseScore": noiseScore,
      "deskScore": deskScore,
      "ventilationScore": ventilationScore,
      "lightingScore": lightingScore,
      "meetingFriendly": meetingFriendly,
      "openArea": openArea,
      "petFriendly": petFriendly,
      "hasParking": hasParking,
      "hasView": hasView,
      "comment": comment,
      "photoUrl": photoUrl,
    };
  }
}
