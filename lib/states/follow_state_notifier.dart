import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/repositories/follow_repository.dart';
import 'package:Wetieko/models/follow_model.dart';

class FollowStateNotifier extends ChangeNotifier {
  final FollowRepository _repo;

  List<FollowModel> _followers = [];
  List<FollowModel> get followers => _followers;

  List<FollowModel> _following = [];
  List<FollowModel> get following => _following;

  List<FollowModel> _pendingRequests = [];
  List<FollowModel> get pendingRequests => _pendingRequests;

  List<FollowModel> _acceptedRequests = [];
  List<FollowModel> get acceptedRequests => _acceptedRequests;

  int get followerCount => _followers.length;
  int get followingCount => _following.length;
  int get pendingCount => _pendingRequests.length;
  int get acceptedCount => _acceptedRequests.length;

  String? _followStatus; // none, pending, accepted
  String? get followStatus => _followStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  FollowStateNotifier(this._repo);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchFollowers(String userId) async {
    _setLoading(true);
    try {
      _followers = await _repo.getFollowers(userId);
      _error = null;
    } catch (_) {
      _error = "Takipçiler yüklenemedi";
    }
    _setLoading(false);
  }

  Future<void> fetchFollowing(String userId) async {
    _setLoading(true);
    try {
      _following = await _repo.getFollowing(userId);
      _error = null;
    } catch (_) {
      _error = "Takip edilenler yüklenemedi";
    }
    _setLoading(false);
  }

  Future<void> fetchPendingRequests() async {
    _setLoading(true);
    try {
      _pendingRequests = await _repo.getPendingRequests();
      _error = null;
    } catch (_) {
      _error = "Bekleyen takip istekleri yüklenemedi";
    }
    _setLoading(false);
  }

  Future<void> fetchAcceptedRequests() async {
    _setLoading(true);
    try {
      _acceptedRequests = await _repo.getAcceptedRequests();
      _error = null;
    } catch (_) {
      _error = "Kabul edilen takip istekleri yüklenemedi";
    }
    _setLoading(false);
  }

  Future<void> fetchFollowersAndFollowing(String userId) async {
    _setLoading(true);
    try {
      _followers = await _repo.getFollowers(userId);
      _following = await _repo.getFollowing(userId);
      _error = null;
    } catch (_) {
      _error = "Takip bilgileri yüklenemedi";
    }
    _setLoading(false);
  }

  /// ❤️ FOLLOW REQUEST – artık bildirim GÖNDERMİYOR
  Future<void> sendFollowRequest(String userId) async {
    _setLoading(true);
    try {
      await _repo.sendFollowRequest(userId);
      _followStatus = "pending";
      _error = null;
    } catch (_) {
      _error = "Takip isteği gönderilemedi";
    }
    _setLoading(false);
  }

  Future<void> unfollow(String userId) async {
    _setLoading(true);
    try {
      await _repo.unfollow(userId);
      _followStatus = "none";
      _error = null;
    } catch (_) {
      _error = "Takipten çıkılamadı";
    }
    _setLoading(false);
  }

  Future<void> removeFollower(String userId) async {
    _setLoading(true);
    try {
      await _repo.removeFollower(userId);
      _followers.removeWhere((f) => f.follower.id == userId);
      _error = null;
    } catch (_) {
      _error = "Takipçi kaldırılamadı";
    }
    _setLoading(false);
  }

  Future<void> fetchFollowStatus(String followingId) async {
    _setLoading(true);
    try {
      final status = await _repo.getFollowStatus(followingId);
      _followStatus = status.toString().toLowerCase();
      _error = null;
    } catch (_) {
      _error = "Durum alınamadı";
    }
    _setLoading(false);
  }

  Future<void> cancelPendingRequest(String userId) async {
    _setLoading(true);
    try {
      await _repo.cancelFollowRequest(userId);
      _followStatus = "none";
      _error = null;
    } catch (_) {
      _error = "Takip isteği iptal edilemedi";
    }
    _setLoading(false);
  }

  Future<void> updateFollowRequestStatus(String followId, String status) async {
    _setLoading(true);
    try {
      await _repo.updateFollowStatus(followId, status);
      _pendingRequests.removeWhere((req) => req.id == followId);
      _error = null;
    } catch (_) {
      _error = "Takip isteği güncellenemedi";
    }
    _setLoading(false);
  }

  void reset() {
    _followers.clear();
    _following.clear();
    _pendingRequests.clear();
    _acceptedRequests.clear();
    _followStatus = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
