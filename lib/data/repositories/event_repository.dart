import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/models/create_event_dto.dart';
import 'package:Wetieko/models/update_event_dto.dart';
import 'package:Wetieko/data/sources/event_remote_data_source.dart';
import 'package:Wetieko/models/filter_event_dto.dart';
import 'package:Wetieko/models/filter_birlikte_calis_dto.dart';

class EventRepository {
  final EventRemoteDataSource remote;

  EventRepository(this.remote);

  Future<List<EventModel>> getEvents({EventType? type}) {
    return remote.getEvents(type: type); // type parametresi opsiyonel olarak kullanılabilir
  }

  Future<EventModel> getEventDetail(String eventId) {
    return remote.getEventDetail(eventId);
  }

  Future<EventModel> createEvent(CreateEventDto dto) {
    return remote.createEvent(dto);
  }

  Future<EventModel> updateEvent(String eventId, UpdateEventDto dto) {
    return remote.updateEvent(eventId, dto);
  }

  Future<void> deleteEvent(String eventId) {
    return remote.deleteEvent(eventId);
  }

  Future<void> joinEvent(String eventId) {
    return remote.joinEvent(eventId);
  }

  Future<void> leaveEvent(String eventId) {
    return remote.leaveEvent(eventId);
  }

  // ✅ Yeni: Katıldığı etkinlikler
  Future<List<EventModel>> getJoinedEvents() {
    return remote.getJoinedEvents();
  }


  Future<List<EventModel>> getCreatedEvents() {
    return remote.getCreatedEvents();
  }

  Future<Map<String, int>> getJoinedEventCounts(String userId) {
  return remote.getJoinedEventCounts(userId);
}

 Future<List<EventModel>> filterEvents(FilterEventDto dto) {
    return remote.filterEvents(dto);
  }

 Future<List<EventModel>> filterBirlikteCalis(FilterBirlikteCalisDto dto) {
    return remote.filterBirlikteCalis(dto);
  }
  
}
