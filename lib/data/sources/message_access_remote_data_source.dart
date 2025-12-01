// lib/data/sources/message_access_remote_data_source.dart

import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/user_model.dart';

class MessageAccessRemoteDataSource {
  final ApiService api;

  MessageAccessRemoteDataSource(this.api);

  Future<void> requestAccess(String receiverId) async {
    final url = '/api/message-access/request/$receiverId';
    print('📨 [REQUEST ACCESS] → POST $url');

    final res = await api.post(url, {});

    print('✅ [REQUEST ACCESS RESPONSE] Status: ${res.statusCode}');
    print('📦 Response Data: ${res.data}');
  }

Future<void> acceptRequest(String requestId) async {
  print("🆔 [ACCEPT REQUEST ID] → $requestId");   // <-- BURADA

  final url = '/api/message-access/accept/$requestId';
  print('✔️ [ACCEPT REQUEST] → POST $url');

  final res = await api.post(url, {});

  print('📌 [ACCEPT RESPONSE] Status: ${res.statusCode}');
  print('📦 Response Data: ${res.data}');
}


  Future<void> rejectRequest(String requestId) async {
    final url = '/api/message-access/reject/$requestId';
    print('❌ [REJECT REQUEST] → POST $url');

    final res = await api.post(url, {});

    print('📌 [REJECT RESPONSE] Status: ${res.statusCode}');
    print('📦 Response Data: ${res.data}');
  }

  Future<List<Map<String, dynamic>>> getIncomingRequests() async {
  const url = '/api/message-access/incoming';
  print('📥 [GET INCOMING REQUESTS] → GET $url');

  final res = await api.get(url);

  print('📌 Status: ${res.statusCode}');
  print('📦 Incoming Requests Raw: ${res.data}');

  // güvenlik kontrolü
  if (res.data == null || res.data["data"] == null) {
    print("⚠️ Backend data null → empty list");
    return [];
  }

  // asıl data burası!
  final list = List<Map<String, dynamic>>.from(res.data["data"]);

  print("📥 Parsed Incoming → $list");

  return list;
}



  Future<List<Map<String, dynamic>>> getOutgoingRequests() async {
    const url = '/api/message-access/outgoing';
    print('📤 [GET OUTGOING REQUESTS] → GET $url');

    final res = await api.get(url);

    print('📌 Status: ${res.statusCode}');
    print('📦 Outgoing Requests Data: ${res.data}');

    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<bool> hasAccess(String receiverId) async {
    final url = '/api/message-access/has/$receiverId';
    print('🔎 [CHECK ACCESS] → GET $url');

    final res = await api.get(url);

    print('📌 Status: ${res.statusCode}');
    print('📦 Check Access Data: ${res.data}');

    final hasAccess = res.data['hasAccess'] == true;
    print('🔐 Access Result → $hasAccess');

    return hasAccess;
  }

  Future<List<Map<String, dynamic>>> getAccessList() async {
    const url = '/api/message-access/list';
    print('📚 [ACCESS LIST] → GET $url');

    final res = await api.get(url);

    print('📌 Status: ${res.statusCode}');
    print('📦 Access List Data: ${res.data}');

    return List<Map<String, dynamic>>.from(res.data);
  }
}
