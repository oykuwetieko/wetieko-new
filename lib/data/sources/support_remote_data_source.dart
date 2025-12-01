import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/support_model.dart';

class SupportRemoteDataSource {
  final ApiService api;

  SupportRemoteDataSource(this.api);

  Future<void> sendSupport(Support support) async {

    try {
      final response = await api.post('/api/support', support.toJson());

      final data = response.data;
    } catch (e, stack) {
    
    }
  }
}
