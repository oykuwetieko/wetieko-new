import 'package:dio/dio.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/place_model.dart';

class FavoriteRemoteDataSource {
  final ApiService api;

  FavoriteRemoteDataSource(this.api);

  Future<void> addFavorite(String placeId) async {
    await api.post(
      '/api/favorites/add',
      {'placeId': placeId},
    );
  }

  Future<void> removeFavorite(String placeId) async {
    // DELETE yerine POST bekliyor dediğin için
    await api.post('/api/favorites/delete/$placeId', {});
  }

  Future<List<Place>> getFavorites() async {
    final response = await api.get('/api/favorites/list');
    final data = response.data;

    if (data is List) {
      return data.map((json) {
        final placeJson = json['place'];
        if (placeJson != null) {
          return Place.fromJson(placeJson);
        } else {
          throw Exception("Favori objesinde 'place' eksik.");
        }
      }).toList();
    } else {
      throw Exception("Favori mekanlar listesi alınamadı.");
    }
  }
}
