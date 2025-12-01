import 'dart:async'; // ✅ Cooldown için gerekli
import 'package:flutter/material.dart';
import 'package:Wetieko/data/repositories/place_repository.dart';
import 'package:Wetieko/data/repositories/feedback_repository.dart';
import 'package:Wetieko/data/repositories/favorite_repository.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/feedback_model.dart';
import 'package:Wetieko/models/checkin_model.dart';
import 'package:Wetieko/models/user_model.dart';

class PlaceStateNotifier extends ChangeNotifier {
  final PlaceRepository placeRepo;
  final FeedbackRepository feedbackRepo;
  final FavoriteRepository favoriteRepo;

  List<Place> _places = [];
  Place? _selectedPlace;
  bool _isLoading = false;
  String? _error;
  String? _lastFetchedCity;

  List<User> _placeAttendees = [];
  List<User> get placeAttendees => _placeAttendees;

  List<PlaceFeedback> _myFeedbacks = [];
  List<PlaceFeedback> get myFeedbacks => _myFeedbacks;

  List<Place> _favorites = [];
  List<Place> get favorites => _favorites;

  List<CheckIn> _myCheckIns = [];
  List<CheckIn> get myCheckIns => _myCheckIns;

  List<CheckIn> _placeCheckIns = [];
  List<CheckIn> get placeCheckIns => _placeCheckIns;

  // ✅ Check-in sayacı getter’ları
  int get myCheckInCount => _myCheckIns.length;
  int get placeCheckInCount => _placeCheckIns.length;

  String? get lastFetchedCity => _lastFetchedCity;

  // ✅ Mekan bazlı cooldown
  final Map<String, bool> _recentCheckIns = {}; // placeId -> cooldown
  final Map<String, Timer> _checkInCooldownTimers = {}; // placeId -> Timer

  bool isRecentlyCheckedIn(String placeId) => _recentCheckIns[placeId] ?? false;

  /// ✅ UI için kullanılacak: cooldown + expiry
  bool isDisabledForPlace(String placeId) {
    final ci = _myCheckIns.firstWhere(
      (c) => c.placeId.trim().toLowerCase() == placeId.trim().toLowerCase(),
      orElse: () => CheckIn.empty(),
    );

    if (ci.id.isNotEmpty) {
      final stillValid =
          ci.expiresAt != null && ci.expiresAt!.isAfter(DateTime.now());


      return stillValid;
    }

    return _recentCheckIns[placeId] ?? false;
  }

  PlaceStateNotifier({
    required this.placeRepo,
    required this.feedbackRepo,
    required this.favoriteRepo,
  });

  List<Place> get places => _places;
  Place? get selectedPlace => _selectedPlace;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ------------------------------
  // Mekan işlemleri
  // ------------------------------
  Future<void> loadPlaces({String city = "İstanbul"}) async {
    _setLoading(true);
    try {
      _places = await placeRepo.getPlacesByCity(city);
      _lastFetchedCity = city;
      _error = null;
    } catch (e) {
      _error = 'Mekanlar yüklenemedi';
    }
    _setLoading(false);
  }

  Future<void> loadFilteredPlaces(Map<String, dynamic> filters) async {
    _setLoading(true);
    try {
      _places = await placeRepo.filterPlaces(filters);
      _error = null;
    } catch (e) {
      _error = 'Filtreli mekanlar yüklenemedi';
    }
    _setLoading(false);
  }

  Future<void> loadPlaceDetail(String placeId) async {
    _setLoading(true);
    try {
      _selectedPlace = await placeRepo.getPlaceDetail(placeId);
      _error = null;
    } catch (e) {
     // _error = 'Mekan detayı alınamadı';
    }
    _setLoading(false);
  }

  // ------------------------------
  // Feedback işlemleri
  // ------------------------------
 Future<void> loadMyFeedbacks() async {
  _setLoading(true);
  try {
    final feedbackList = await feedbackRepo.getMyFeedbacks();

    _myFeedbacks = feedbackList.map((fb) {
      // 🔥 DB ID eşleşmesi (Google Place ID değil!)
      final matchedPlace = _places.firstWhere(
        (p) => p.id.toString() == fb.placeDbId.toString(),
        orElse: () => Place.empty(),
      );

        return PlaceFeedback(
          id: fb.id,
          placeDbId: fb.placeDbId,    
          userId: fb.userId,
          wifi: fb.wifi,
          socket: fb.socket,
          noiseLevel: fb.noiseLevel,
          workDesk: fb.workDesk,
          ventilation: fb.ventilation,
          lighting: fb.lighting,
          hasMeetingArea: fb.hasMeetingArea,
          hasOutdoorArea: fb.hasOutdoorArea,
          isPetFriendly: fb.isPetFriendly,
          hasParking: fb.hasParking,
          hasView: fb.hasView,
          comment: fb.comment,
          photoUrl: fb.photoUrl,
          createdAt: fb.createdAt,
          userName: fb.userName,
          userProfileImage: fb.userProfileImage,
          userCareerPosition: fb.userCareerPosition,
          placeName: fb.placeName ?? matchedPlace.name,
          placeAddress: fb.placeAddress ?? matchedPlace.formattedAddress,
          place: matchedPlace.id.isEmpty ? null : matchedPlace,
        );
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Yorumlar alınamadı';
      _myFeedbacks = [];
    }
    _setLoading(false);
  }

  Future<List<PlaceFeedback>> loadFeedbacksByUser(String userId) async {
    _setLoading(true);
    try {
      final feedbackList = await feedbackRepo.getFeedbacksByUserId(userId);

      final updatedFeedbacks = feedbackList.map((fb) {
      // 🔥 Google Place ID değil, DB id matching
      final matchedPlace = _places.firstWhere(
        (p) => p.id == fb.placeDbId.toString(),
        orElse: () => Place.empty(),
      );

      return PlaceFeedback(
        id: fb.id,
        userId: fb.userId,
        placeDbId: fb.placeDbId,
          wifi: fb.wifi,
          socket: fb.socket,
          noiseLevel: fb.noiseLevel,
          workDesk: fb.workDesk,
          ventilation: fb.ventilation,
          lighting: fb.lighting,
          hasMeetingArea: fb.hasMeetingArea,
          hasOutdoorArea: fb.hasOutdoorArea,
          isPetFriendly: fb.isPetFriendly,
          hasParking: fb.hasParking,
          hasView: fb.hasView,
          comment: fb.comment,
          photoUrl: fb.photoUrl,
          createdAt: fb.createdAt,
          userName: fb.userName,
          userProfileImage: fb.userProfileImage,
          userCareerPosition: fb.userCareerPosition,
          placeName: fb.placeName ?? matchedPlace.name,
          placeAddress: fb.placeAddress ?? matchedPlace.formattedAddress,
          place: matchedPlace.id.isEmpty ? null : matchedPlace,
        );
      }).toList();

      _setLoading(false);
      return updatedFeedbacks;
    } catch (e) {
      _error = 'Kullanıcı yorumları alınamadı';
      _setLoading(false);
      return [];
    }
  }

  Future<void> submitFeedback(FeedbackDto dto) async {
  _setLoading(true);
  try {
    await feedbackRepo.submitFeedback(dto);

    // 🔥 DB ID → String Google Place ID bekleyen metoda gönderilemez
    await loadPlaceDetail(dto.placeDbId.toString());

    _error = null;
  } catch (e) {
    _error = 'Yorum gönderilemedi';
  }
  _setLoading(false);
}


Future<void> deleteFeedback(String feedbackId) async {
  _setLoading(true);
  try {
    // API string bekliyor → zaten String geliyor
    await feedbackRepo.deleteFeedback(feedbackId);

    final before = _myFeedbacks.length;

    // 🔥 id artık int olduğu için karşılaştırma numeric yapılmalı
    _myFeedbacks = List.from(_myFeedbacks)
      ..removeWhere((fb) => fb.id.toString() == feedbackId);

    final after = _myFeedbacks.length;

    print("🗑️ deleteFeedback: before=$before, after=$after, silinen=$feedbackId");

    _error = null;
    notifyListeners();
  } catch (e) {
    _error = 'Yorum silinemedi';
    print("❌ deleteFeedback hata: $e");
  }
  _setLoading(false);
}




  // ------------------------------
  // Favoriler
  // ------------------------------
  Future<void> loadFavorites() async {
    _setLoading(true);
    try {
      _favorites = await favoriteRepo.getFavorites();
      _error = null;
    } catch (e) {
      _error = 'Favoriler alınamadı';
    }
    _setLoading(false);
  }

Future<bool> addFavorite(String placeId) async {
  _setLoading(true);
  try {
    await favoriteRepo.addFavorite(placeId);
    final place = _places.firstWhere(
      (p) => p.id == placeId,
      orElse: () => Place.empty(),
    );
    if (place.id.isNotEmpty && !_favorites.any((p) => p.id == placeId)) {
      _favorites.add(place);
    }
    _error = null;
    _setLoading(false);
    return true; // ✅ başarı
  } catch (e) {
    _error = 'Favori eklenemedi';
    debugPrint("❌ addFavorite error: $e");
    _setLoading(false);
    return false; // ❌ hata
  }
}

Future<bool> removeFavorite(String placeId) async {
  _setLoading(true);
  try {
    await favoriteRepo.removeFavorite(placeId);
    _favorites.removeWhere((p) => p.id == placeId);
    _error = null;
    _setLoading(false);
    return true; // ✅ başarı
  } catch (e) {
    _error = 'Favori silinemedi';
    debugPrint("❌ removeFavorite error: $e");
    _setLoading(false);
    return false; // ❌ hata
  }
}



  bool isFavorite(String placeId) {
    return _favorites.any((p) => p.id == placeId);
  }

  // ------------------------------
  // Check-in işlemleri
  // ------------------------------
  Future<void> addCheckIn(String placeId) async {
    if (_recentCheckIns[placeId] == true) {
      print("⏳ [addCheckIn] $placeId için cooldown devam ediyor.");
      return;
    }

    _setLoading(true);
    try {
      final result = await placeRepo.createCheckIn(placeId);

      if (result.isRecentlyCheckedIn) {
        _recentCheckIns[placeId] = true;
        notifyListeners();

        if (result.expiresAt != null) {
          final remaining = result.expiresAt!.difference(DateTime.now()).inSeconds;

          _checkInCooldownTimers[placeId]?.cancel();
          _checkInCooldownTimers[placeId] =
              Timer(Duration(seconds: remaining), () {
            _recentCheckIns[placeId] = false;
            notifyListeners();
            print("⏱️ [$placeId] cooldown bitti, tekrar check-in yapılabilir.");
          });
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Check-in yapılamadı';
      _recentCheckIns[placeId] = false;
      print("❌ [addCheckIn] Hata: $e");
    }
    _setLoading(false);
  }

  Future<void> loadMyCheckIns(String userId) async {
    _setLoading(true);
    try {
      final list = await placeRepo.getUserCheckIns(userId);
      print("📌 loadMyCheckIns: ${list.length} kayıt geldi");

      _myCheckIns = list;

      for (final ci in _myCheckIns) {
        print("➡️ CheckIn placeId=${ci.placeId}, expiresAt=${ci.expiresAt}");
        if (ci.expiresAt != null && ci.expiresAt!.isAfter(DateTime.now())) {
          final remaining = ci.expiresAt!.difference(DateTime.now()).inSeconds;
          _recentCheckIns[ci.placeId] = true;

          _checkInCooldownTimers[ci.placeId]?.cancel();
          _checkInCooldownTimers[ci.placeId] =
              Timer(Duration(seconds: remaining), () {
            _recentCheckIns[ci.placeId] = false;
            notifyListeners();
            print("⏱️ [${ci.placeId}] cooldown bitti (loadMyCheckIns).");
          });
        }
      }

      _error = null;
    } catch (e, st) {
      print("❌ loadMyCheckIns HATA: $e\n$st");
      _error = 'Check-in listesi alınamadı';
    }
    _setLoading(false);
  }

  Future<void> loadCheckInsByPlace(String placeId) async {
    _setLoading(true);
    try {
      _placeAttendees = await placeRepo.getPlaceAttendees(placeId);
      _placeCheckIns = []; // sadece kullanıcılar geldiği için boş bırakıyoruz
      _error = null;
    } catch (e) {
      _error = 'Mekanın katılımcıları alınamadı';
      _placeAttendees = [];
    }
    _setLoading(false);
  }

  // ------------------------------
  // Yardımcı
  // ------------------------------
  void resetSelectedPlace() {
    _selectedPlace = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _checkInCooldownTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
