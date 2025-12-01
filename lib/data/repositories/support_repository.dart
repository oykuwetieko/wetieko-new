import 'package:Wetieko/data/sources/support_remote_data_source.dart';
import 'package:Wetieko/models/support_model.dart';

class SupportRepository {
  final SupportRemoteDataSource remote;

  SupportRepository(this.remote);

  Future<void> sendSupport(Support support) {
    return remote.sendSupport(support);
  }
}
