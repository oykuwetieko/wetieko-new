import 'package:dio/dio.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/message_model.dart';

class MessageRemoteDataSource {
  final ApiService api;

  MessageRemoteDataSource(this.api);

  /* ----------------------------------------------------------
   *  📩 Yeni mesaj gönder
   * ---------------------------------------------------------- */
  Future<MessageModel> sendMessage(String receiverId, String content) async {
    const endpoint = '/api/messages';

    print('📡 POST $endpoint');
    print('➡️ Body: { receiverId: $receiverId, content: $content }');

    try {
      final response = await api.post(
        endpoint,
        {
          'receiverId': receiverId,
          'content': content,
        },
      );

      print('✅ Status Code: ${response.statusCode}');
      print('📥 Response: ${response.data}');

      return MessageModel.fromJson(response.data);
    } catch (e) {
      print('❌ sendMessage ERROR: $e');
      rethrow;
    }
  }

  /* ----------------------------------------------------------
   *  📚 Tüm mesajları getir
   * ---------------------------------------------------------- */
  Future<List<MessageModel>> getAllMessages() async {
    const endpoint = '/api/messages';

    print('📡 GET $endpoint');

    try {
      final response = await api.get(endpoint);

      print('✅ Status Code: ${response.statusCode}');
      print('📥 Raw Response: ${response.data}');

      final List<dynamic> data = response.data;
      final messages = data.map((json) => MessageModel.fromJson(json)).toList();

      print('📦 Parsed Messages Count: ${messages.length}');

      return messages;
    } catch (e) {
      print('❌ getAllMessages ERROR: $e');
      rethrow;
    }
  }

  /* ----------------------------------------------------------
   *  👥 Konuşma listesi (her kullanıcıyla son mesaj)
   * ---------------------------------------------------------- */
  Future<List<MessageModel>> getConversationList() async {
  const endpoint = '/api/messages/conversations/list';

  print('📡 GET $endpoint');

  try {
    final response = await api.get(endpoint);

    print('✅ Status Code: ${response.statusCode}');
    print('📥 Raw Response: ${response.data}');

    // ❗ Backend burada MAP döndürüyor:
    // { isSuccess: true, data: [...] }
    final List<dynamic> data = response.data["data"];

    final messages = data.map((json) => MessageModel.fromJson(json)).toList();

    print('📦 Conversation List Count: ${messages.length}');

    return messages;
  } catch (e) {
    print('❌ getConversationList ERROR: $e');
    rethrow;
  }
}


  /* ----------------------------------------------------------
   *  🔢 Toplam okunmamış mesaj sayısı
   * ---------------------------------------------------------- */
  Future<Map<String, dynamic>> getUnreadCount() async {
    const endpoint = '/api/messages/unread/count';

    print('📡 GET $endpoint');

    try {
      final response = await api.get(endpoint);

      print('✅ Status Code: ${response.statusCode}');
      print('📥 Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        print('🔢 Unread Count: ${response.data}');
        return response.data;
      } else {
        print('⚠️ Unexpected unread count response type!');
        return {'unreadCount': 0};
      }
    } catch (e) {
      print('❌ getUnreadCount ERROR: $e');
      return {'unreadCount': 0};
    }
  }

  /* ----------------------------------------------------------
   *  💬 Belirli kullanıcı ile mesajlaşma geçmişi
   * ---------------------------------------------------------- */
  Future<List<MessageModel>> getConversation(String otherUserId) async {
  final endpoint = '/api/messages/$otherUserId';

  print('📡 GET $endpoint');

  try {
    final response = await api.get(endpoint);

    print('✅ Status Code: ${response.statusCode}');
    print('📥 Raw Response: ${response.data}');

    final List<dynamic> data = response.data["data"];

    final messages = data.map((json) => MessageModel.fromJson(json)).toList();

    print('📦 Conversation Messages Count: ${messages.length}');

    return messages;
  } catch (e) {
    print('❌ getConversation ERROR: $e');
    rethrow;
  }
}

  /* ----------------------------------------------------------
   *  🗑 Mesaj sil
   * ---------------------------------------------------------- */
 Future<void> deleteMessage(String messageId) async {
  final endpoint = '/api/messages/$messageId';

  print('🗑 POST $endpoint');
  print('➡️ Body: {} (boş gönderiliyor)');

  try {
    final response = await api.post(endpoint, {});

    print('✅ Status Code: ${response.statusCode}');
    print('🗑 Message deleted successfully');
  } catch (e) {
    print('❌ deleteMessage ERROR: $e');
    rethrow;
  }
}


  /* ----------------------------------------------------------
   *  👁 Mesajları okundu işaretle
   * ---------------------------------------------------------- */
  Future<void> markAsRead(String otherUserId) async {
    const endpoint = '/api/messages/mark-as-read';

    print('📡 POST $endpoint');
    print('➡️ Body: { otherUserId: $otherUserId }');

    try {
      final response = await api.post(
        endpoint,
        {'otherUserId': otherUserId},
      );

      print('✅ Status Code: ${response.statusCode}');
      print('📥 Response: ${response.data}');
    } on DioException catch (e) {
      print('⚠️ markAsRead ERROR: ${e.message}');
    } catch (e) {
      print('❌ markAsRead UNKNOWN ERROR: $e');
    }
  }
}
