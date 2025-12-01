class AddFavoriteRequestDto {
  final int placeId;

  AddFavoriteRequestDto({required this.placeId});

  Map<String, dynamic> toJson() {
    return {
      "placeId": placeId,
    };
  }
}
