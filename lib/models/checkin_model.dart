import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/user_model.dart';

class CheckIn {
  final String id;
  final String userId;
  final String placeId; // 👉 artık hem placeDbId hem placeId'yi okuyacak
  final DateTime createdAt;
  final DateTime updatedAt;
  final Place? place;
  final User? user;

  // ✅ yeni alan: backend'de var (null olabilir)
  final String? comment;

  // ✅ cooldown kontrolü için
  final bool isRecentlyCheckedIn;
  final DateTime? expiresAt;

  CheckIn({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.createdAt,
    required this.updatedAt,
    this.place,
    this.user,
    this.comment,
    this.isRecentlyCheckedIn = false,
    this.expiresAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',

      // ✅ önce placeDbId varsa onu al, yoksa placeId
      placeId: json['placeDbId'] ?? json['placeId'] ?? '',

      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
      user: json['user'] != null
          ? User.fromJson(json['user'], accessToken: null)
          : null,

      // ✅ yeni: comment
      comment: json['comment'],

      // ✅ backend’den gelen cooldown bilgisi
      isRecentlyCheckedIn: json['isRecentlyCheckedIn'] ?? false,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return DateTime.now();
  }

  factory CheckIn.empty() {
    return CheckIn(
      id: '',
      userId: '',
      placeId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      comment: null,
      isRecentlyCheckedIn: false,
      expiresAt: null,
    );
  }
}

class CheckInResponse {
  final bool isRecentlyCheckedIn;
  final DateTime? expiresAt;

  CheckInResponse({
    required this.isRecentlyCheckedIn,
    this.expiresAt,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      isRecentlyCheckedIn: json['isRecentlyCheckedIn'] == true,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }
}
