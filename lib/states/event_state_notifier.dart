import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/repositories/event_repository.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/models/create_event_dto.dart';
import 'package:Wetieko/models/update_event_dto.dart';
import 'package:Wetieko/models/filter_event_dto.dart';
import 'package:Wetieko/models/filter_birlikte_calis_dto.dart';

class EventStateNotifier extends ChangeNotifier {
  final EventRepository _repo;

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  List<EventModel> _joinedEvents = [];
  List<EventModel> get joinedEvents => _joinedEvents;

  List<EventModel> _createdEvents = [];
  List<EventModel> get createdEvents => _createdEvents;

  Map<String, int>? _joinedCountsByType;
  Map<String, int>? get joinedCountsByType => _joinedCountsByType;

  bool _isFiltered = false;
  bool get isFiltered => _isFiltered;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EventStateNotifier(this._repo);

  /// ✅ Tüm etkinlikleri getir
  Future<void> fetchEvents({EventType? type}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _events = await _repo.getEvents(type: type);
      _isFiltered = false;
    } catch (e) {
      debugPrint('fetchEvents error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Katıldığı etkinlikleri getir
  Future<void> fetchJoinedEvents() async {
    try {
      _joinedEvents = await _repo.getJoinedEvents();
      notifyListeners();
    } catch (e) {
      debugPrint('fetchJoinedEvents error: $e');
      rethrow;
    }
  }

  /// ✅ Kullanıcının oluşturduğu etkinlikleri getir
  Future<void> fetchCreatedEvents() async {
    try {
      _createdEvents = await _repo.getCreatedEvents();
      notifyListeners();
    } catch (e) {
      debugPrint('fetchCreatedEvents error: $e');
      rethrow;
    }
  }

  /// ✅ Kullanıcının katıldığı etkinlik türü sayılarını getir
  Future<void> fetchJoinedCounts(String userId) async {
    try {
      _joinedCountsByType = await _repo.getJoinedEventCounts(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('fetchJoinedCounts error: $e');
      rethrow;
    }
  }

  /// ✅ Yeni etkinlik oluştur
  Future<void> createEvent(CreateEventDto dto) async {
    try {
      final newEvent = await _repo.createEvent(dto);
      _events.insert(0, newEvent);
      _createdEvents.insert(0, newEvent);
      notifyListeners();
    } catch (e) {
      debugPrint('createEvent error: $e');
      rethrow;
    }
  }

  /// ✅ Var olan etkinliği güncelle
  Future<void> updateEvent(String id, UpdateEventDto dto) async {
    try {
      final updatedEvent = await _repo.updateEvent(id, dto);

      final index = _events.indexWhere((e) => e.id == id);
      if (index != -1) _events[index] = updatedEvent;

      final createdIndex = _createdEvents.indexWhere((e) => e.id == id);
      if (createdIndex != -1) _createdEvents[createdIndex] = updatedEvent;

      notifyListeners();
    } catch (e) {
      debugPrint('updateEvent error: $e');
      rethrow;
    }
  }

  /// ✅ Etkinlik sil
  Future<void> deleteEvent(String id) async {
    try {
      await _repo.deleteEvent(id);

      _events.removeWhere((e) => e.id == id);
      _createdEvents.removeWhere((e) => e.id == id);
      _joinedEvents.removeWhere((e) => e.id == id);

      notifyListeners();
    } catch (e) {
      debugPrint('deleteEvent error: $e');
      rethrow;
    }
  }

  /// ✅ Etkinliğe katıl
  Future<void> joinEvent(String id) async {
    try {
      await _repo.joinEvent(id);
      await fetchEvents();
      await fetchJoinedEvents();
    } catch (e) {
      debugPrint('joinEvent error: $e');
      rethrow;
    }
  }

  /// ✅ Etkinlikten ayrıl
  Future<void> leaveEvent(String id) async {
    try {
      await _repo.leaveEvent(id);
      await fetchEvents();
      await fetchJoinedEvents();
    } catch (e) {
      debugPrint('leaveEvent error: $e');
      rethrow;
    }
  }

  /// ✅ Tek bir etkinlik detayını getir
  Future<EventModel> fetchEventDetail(String id) async {
    try {
      return await _repo.getEventDetail(id);
    } catch (e) {
      debugPrint('fetchEventDetail error: $e');
      rethrow;
    }
  }

  /// ✅ Filtreli etkinlikleri getir
  Future<void> fetchFilteredEvents(FilterEventDto dto) async {
    try {
      _events = await _repo.filterEvents(dto);
      _isFiltered = true;
      notifyListeners();
    } catch (e) {
      debugPrint('fetchFilteredEvents error: $e');
      rethrow;
    }
  }

  /// ✅ "Birlikte Çalış" filtreli etkinlikleri getir
  Future<void> fetchFilteredBirlikteCalis(FilterBirlikteCalisDto dto) async {
    try {
      _events = await _repo.filterBirlikteCalis(dto);
      _isFiltered = true;
      notifyListeners();
    } catch (e) {
      debugPrint('fetchFilteredBirlikteCalis error: $e');
      rethrow;
    }
  }
}
