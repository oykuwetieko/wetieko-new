import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/checkin_model.dart';
import 'package:Wetieko/models/user_model.dart';

class PlaceRemoteDataSource {
  final ApiService api;

  PlaceRemoteDataSource(this.api);

  dynamic _extract(dynamic raw) {
    if (raw == null) return null;

    while (raw is Map && raw.containsKey("data")) {
      raw = raw["data"];
    }

    return raw;
  }

  Future<List<Place>> getPlacesByCity(String city) async {
    final response = await api.get(
      '/api/Places/list',
      queryParameters: {'city': city},
    );

    final extracted = _extract(response.data);

    if (extracted is List) {
      return extracted.map((e) => Place.fromJson(e)).toList();
    }

    return [];
  }

  Future<Place> getPlaceDetail(String placeId) async {
    final response = await api.get('/api/Places/details/$placeId');

    final extracted = _extract(response.data);

    return Place.fromJson(extracted ?? {});
  }

  Future<List<Place>> filterPlaces(Map<String, dynamic> filters) async {
    final response = await api.post('/api/Places/filter-list', filters);

    final extracted = _extract(response.data);

    if (extracted is List) {
      return extracted.map((e) => Place.fromJson(e)).toList();
    }

    return [];
  }

  Future<CheckInResponse> createCheckIn(String placeDbId) async {
    final response = await api.post(
      '/api/Places/check-in',
      {
        "placeDbId": placeDbId,
      },
    );

    final extracted = _extract(response.data);

    return CheckInResponse.fromJson(extracted ?? {});
  }

  Future<List<CheckIn>> getUserCheckIns(String userId) async {
    final response = await api.get(
      '/api/Places/check-ins/user',
      queryParameters: {"userId": userId},
    );

    final extracted = _extract(response.data);

    if (extracted is! List) return [];

    return extracted.map((e) => CheckIn.fromJson(e)).toList();
  }

  Future<List<User>> getPlaceAttendees(String placeDbId) async {
    final response = await api.get(
      '/api/Places/attendees/place',
      queryParameters: {"placeDbId": placeDbId},
    );

    final extracted = _extract(response.data);

    if (extracted is! List) return [];

    return extracted.map((e) {
      return User.fromJson(
        e['user'] ?? {},
        accessToken: null,
      );
    }).toList();
  }
}
