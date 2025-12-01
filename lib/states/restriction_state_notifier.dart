import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/repositories/restriction_repository.dart';

class RestrictionStateNotifier extends ChangeNotifier {
  final RestrictionRepository repo;

  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _restricted = [];
  List<Map<String, dynamic>> get restricted => _restricted;

  // 🔥 Backend check endpoint sonucu
  bool _isBlocked = false;
  bool get isBlocked => _isBlocked;

  RestrictionStateNotifier(this.repo);

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // 📌 Engelli kullanıcı listesini getir (opsiyonel)
  Future<void> fetchRestrictedUsers() async {
    debugPrint('📡 [RestrictionStateNotifier] Engelli kullanıcılar yükleniyor...');
    _setLoading(true);

    try {
      _restricted = await repo.getRestrictedUsers();
      debugPrint('✅ [RestrictionStateNotifier] ${_restricted.length} kullanıcı engelli.');
    } catch (e, stack) {
      debugPrint('❌ [RestrictionStateNotifier] Engelli kullanıcıları getirirken hata: $e');
      debugPrint(stack.toString());
    } finally {
      _setLoading(false);
    }
  }

  // 🚫 Kullanıcıyı engelle
  Future<void> restrictUser(String userId) async {
    debugPrint('🚫 [RestrictionStateNotifier] Kullanıcı engelleniyor: $userId');

    _setLoading(true);

    try {
      await repo.restrictUser(userId);
      debugPrint('✅ [RestrictionStateNotifier] Kullanıcı engellendi: $userId');

      _isBlocked = true; // UI anında güncellenir
      notifyListeners();

      await fetchRestrictedUsers();
    } catch (e, stack) {
      debugPrint('❌ [RestrictionStateNotifier] Engelleme hatası: $e');
      debugPrint(stack.toString());
    } finally {
      _setLoading(false);
    }
  }

  // 🔓 Engeli kaldır
  Future<void> unrestrictUser(String userId) async {
    debugPrint('🔓 [RestrictionStateNotifier] Kullanıcının engeli kaldırılıyor: $userId');

    _setLoading(true);

    try {
      await repo.unrestrictUser(userId);
      debugPrint('✅ [RestrictionStateNotifier] Engel kaldırıldı: $userId');

      _isBlocked = false; // UI anında güncellenir
      notifyListeners();

      await fetchRestrictedUsers();
    } catch (e, stack) {
      debugPrint('❌ [RestrictionStateNotifier] Engel kaldırma hatası: $e');
      debugPrint(stack.toString());
    } finally {
      _setLoading(false);
    }
  }

  // 🔍 Backend check → Kullanıcı gerçekten engelli mi?
  Future<void> checkUserRestriction(String userId) async {
    debugPrint('🔍 [RestrictionStateNotifier] Kullanıcı engelli mi kontrol ediliyor: $userId');

    _setLoading(true);

    try {
      final result = await repo.checkRestriction(userId);
      _isBlocked = result;

      debugPrint('📌 [RestrictionStateNotifier] CHECK sonucu → isBlocked = $_isBlocked');

      notifyListeners();
    } catch (e, stack) {
      debugPrint('❌ [RestrictionStateNotifier] Engel kontrolünde hata: $e');
      debugPrint(stack.toString());
    } finally {
      _setLoading(false);
    }
  }
}
