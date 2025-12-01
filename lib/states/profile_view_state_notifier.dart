import 'package:flutter/material.dart';
import 'package:Wetieko/data/repositories/profile_view_repository.dart';
import 'package:Wetieko/models/profile_view_model.dart';
import 'package:Wetieko/models/user_model.dart';

class ProfileViewStateNotifier extends ChangeNotifier {
  final ProfileViewRepository repo;

  ProfileViewStateNotifier(this.repo);

  List<ProfileView> _views = [];
  List<ProfileView> get views => _views;

  /// Kullanıcı bazında gruplanmış veriler
  Map<String, _ProfileViewSummary> get groupedViews {
    final Map<String, _ProfileViewSummary> map = {};
    for (var v in _views) {
      final viewerId = v.viewer.id;
      if (!map.containsKey(viewerId)) {
        map[viewerId] = _ProfileViewSummary(
          viewer: v.viewer,
          count: 1,
          lastViewedAt: v.createdAt,
        );
      } else {
        map[viewerId] = _ProfileViewSummary(
          viewer: v.viewer,
          count: map[viewerId]!.count + 1,
          lastViewedAt: v.createdAt.isAfter(map[viewerId]!.lastViewedAt)
              ? v.createdAt
              : map[viewerId]!.lastViewedAt,
        );
      }
    }
    return map;
  }

  Future<void> fetchProfileViews(String userId) async {
    final result = await repo.getProfileViews(userId);
    _views = result;
    notifyListeners();
  }

  /// ✅ Artık profil görüntülendiğinde bildirim GÖNDERİLMİYOR
  Future<void> recordProfileView(String viewedUserId) async {
    await repo.recordProfileView(viewedUserId);
    notifyListeners();
  }

  void clear() {
    _views = [];
    notifyListeners();
  }
}

/// Kullanıcıya ait özet bilgi
class _ProfileViewSummary {
  final User viewer;
  final int count;
  final DateTime lastViewedAt;

  _ProfileViewSummary({
    required this.viewer,
    required this.count,
    required this.lastViewedAt,
  });
}
