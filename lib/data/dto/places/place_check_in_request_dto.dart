class PlaceCheckInRequestDto {
  final String? comment;
  final int userId;
  final int placeDbId;

  PlaceCheckInRequestDto({
    this.comment,
    required this.userId,
    required this.placeDbId,
  });

  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
      "userId": userId,
      "placeDbId": placeDbId,
    };
  }
}
