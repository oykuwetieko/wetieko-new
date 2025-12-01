import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/data/sources/favorite_remote_data_source.dart';

class FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepository(this.remoteDataSource);

  Future<void> addFavorite(String placeId) async {
    await remoteDataSource.addFavorite(placeId);
  }

  Future<void> removeFavorite(String placeId) async {
    await remoteDataSource.removeFavorite(placeId);
  }

  Future<List<Place>> getFavorites() async {
    return await remoteDataSource.getFavorites();
  }
}
