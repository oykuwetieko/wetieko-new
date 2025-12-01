import 'package:Wetieko/models/place_model.dart';

class FavoritePlace {
  final String id;
  final String userId;
  final String placeId;
  final DateTime createdAt;
  final Place? place; // Eğer API içinde place objesi varsa

  FavoritePlace({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.createdAt,
    this.place,
  });

  factory FavoritePlace.fromJson(Map<String, dynamic> json) {
    return FavoritePlace(
      id: json['id'],
      userId: json['userId'],
      placeId: json['placeId'],
      createdAt: DateTime.parse(json['createdAt']),
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'createdAt': createdAt.toIso8601String(),
      'place': place?.toJson(),
    };
  }
}
