import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/models/create_event_dto.dart';
import 'package:Wetieko/models/update_event_dto.dart';
import 'package:Wetieko/models/filter_event_dto.dart';
import 'package:Wetieko/models/filter_birlikte_calis_dto.dart';

class EventRemoteDataSource {
  final ApiService api;

  EventRemoteDataSource(this.api);

 Future<List<EventModel>> getEvents({EventType? type}) async {
  final queryParams = type != null ? {'type': type.name} : null;

  final response = await api.get(
    '/api/Events/list',
    queryParameters: queryParams,
  );

  final extracted = response.data['data'];

  if (extracted is! List) {
    return [];
  }

  return extracted.map((e) => EventModel.fromJson(e)).toList();
}


Future<EventModel> getEventDetail(String eventId) async {

  final response = await api.get('/api/Events/$eventId');
  final extracted = response.data?["data"];
  final event = EventModel.fromJson(extracted ?? {});
  return event;
}

  Future<EventModel> createEvent(CreateEventDto dto) async {
  final response = await api.post(
    '/api/Events/create',
    dto.toJson(),
  );
  final extracted = response.data['data'];
  final event = EventModel.fromJson(extracted ?? {});
  return event;
}

Future<void> deleteEvent(String eventId) async {
  final id = int.tryParse(eventId);

  if (id == null) {
  
    return;
  }

  try {
    final response = await api.post('/api/Events/delete/$id', null);
  } catch (e) {
   
    rethrow;
  }

 
}

 Future<void> joinEvent(String eventId) async {
  print("joinEvent() called with eventId: $eventId");

  final intId = int.tryParse(eventId);
  if (intId == null) {
    throw Exception("Invalid eventId: must be integer");
  }
  final url = '/api/Events/$intId/join';

  try {
    final response = await api.post(url, {});

    final data = response.data;

    if (data is Map && data["isSuccess"] == true) {
      print("🎉 joinEvent(): Katılım başarılı");
      return;
    }

    final msg = data['message'] ?? "Join failed";

    throw Exception(msg);
  } catch (e) {
    rethrow;
  }
}

Future<EventModel> updateEvent(String eventId, UpdateEventDto dto) async {

  final url = '/api/Events/$eventId';
  try {
    final response = await api.post(url, dto.toJson());
    final event = EventModel.fromJson(response.data);
    return event;
  } catch (e) {
    rethrow;
  }
}


Future<void> leaveEvent(String eventId) async {
  

  final intId = int.tryParse(eventId);
  if (intId == null) {
    
    throw Exception("Invalid eventId: must be integer");
  }

  final url = '/api/Events/delete/$intId/leave';


  try {
    final response = await api.post(url, {});
   

    if (response.data is Map && response.data["isSuccess"] == true) {
      print("✔️ Successfully left event $intId");
      return;
    }



  } catch (e) {
   
    rethrow;
  }
}



Future<List<EventModel>> getJoinedEvents() async {
  print("getJoinedEvents() called");

  try {
    final response = await api.get('/api/Events/me/joined');
  

    // ❗ Backend format: { isSuccess, message, data: [...] }
    final body = response.data;

    if (body is! Map || body['data'] is! List) {
     
      return [];
    }

    final list = (body['data'] as List).map((e) {
    
      return EventModel.fromJson(e);
    }).toList();

    
    return list;

  } catch (e) {
  
    return [];
  }
}




 Future<List<EventModel>> getCreatedEvents() async {
 
  final response = await api.get('/api/Events/me/created');


  final extracted = response.data['data'];
 

  if (extracted is List) {
    final list = extracted.map((e) {
     
      return EventModel.fromJson(e);
    }).toList();

 
    return list;
  }

  if (extracted is Map<String, dynamic>) {
   
    final event = EventModel.fromJson(extracted);


    return [event];
  }

  return [];
}



Future<Map<String, int>> getJoinedEventCounts(String userId) async {
  
  final response = await api.get('/api/Users/$userId/event-join-stats');



  final data = response.data as Map<String, dynamic>;
 

  final converted = data.map((key, value) {
   
    return MapEntry(key, value as int);
  });


  return converted;
}


  Future<List<EventModel>> filterEvents(FilterEventDto dto) async {
    final response = await api.post('/api/Events/filter', dto.toJson());
    final data = response.data as List;
    return data.map((e) => EventModel.fromJson(e)).toList();
  }

  Future<List<EventModel>> filterBirlikteCalis(FilterBirlikteCalisDto dto) async {
  final response = await api.post('/api/Events/filter/birlikte-calis', dto.toJson());
  final data = response.data as List;
  return data.map((e) => EventModel.fromJson(e)).toList();
}

}
