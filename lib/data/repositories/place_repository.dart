import 'package:Wetieko/data/sources/place_remote_data_source.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/checkin_model.dart';
import 'package:Wetieko/models/user_model.dart';

class PlaceRepository {
  final PlaceRemoteDataSource remote;

  PlaceRepository(this.remote);

  Future<List<Place>> getPlacesByCity(String city) {
    return remote.getPlacesByCity(city);
  }

  Future<Place> getPlaceDetail(String placeId) {
    return remote.getPlaceDetail(placeId);
  }

  Future<List<Place>> filterPlaces(Map<String, dynamic> filters) {
    return remote.filterPlaces(filters);
  }

  // ✅ 1. Check-in oluştur (sadece placeId yeterli, userId JWT’den geliyor)
  Future<CheckInResponse> createCheckIn(String placeId) {
  return remote.createCheckIn(placeId);
}


  // ✅ 2. Kullanıcının check-in geçmişi
  Future<List<CheckIn>> getUserCheckIns(String userId) {
    return remote.getUserCheckIns(userId);
  }

  // ✅ 3. Mekanın check-in listesi
  Future<List<User>> getPlaceAttendees(String placeId) {
    return remote.getPlaceAttendees(placeId);
  }
}
