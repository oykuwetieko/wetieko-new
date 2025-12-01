import 'package:Wetieko/data/sources/message_remote_data_source.dart';
import 'package:Wetieko/models/message_model.dart';

class MessageRepository {
  final MessageRemoteDataSource remote;

  MessageRepository(this.remote);

  /// ✅ Yeni mesaj gönder
  Future<MessageModel> sendMessage(String receiverId, String content) {
    return remote.sendMessage(receiverId, content);
  }

  /// ✅ Kullanıcının tüm mesajlarını getir
  Future<List<MessageModel>> getAllMessages() {
    return remote.getAllMessages();
  }

  /// ✅ Belirli bir kullanıcıyla konuşmaları getir
  Future<List<MessageModel>> getConversation(String otherUserId) {
    return remote.getConversation(otherUserId);
  }

  /// ✅ Konuşma listesi (her kullanıcıyla en son mesaj)
  Future<List<MessageModel>> getConversationList() {
    return remote.getConversationList();
  }

  /// ✅ Mesaj sil
  Future<void> deleteMessage(String messageId) {
    return remote.deleteMessage(messageId);
  }

  // 🆕 ---------------------------------------------------
  // 🆕 Okunmamış mesajlarla ilgili yeni metodlar
  // ---------------------------------------------------

  /// 🆕 Toplam okunmamış mesaj sayısını getir
  Future<int> getUnreadCount() async {
    final response = await remote.getUnreadCount();
    return response['unreadCount'] ?? 0;
  }

  /// 🆕 Mesajları okundu olarak işaretle (HTTP fallback — socket alternatifi)
  Future<void> markAsRead(String otherUserId) {
    return remote.markAsRead(otherUserId);
  }
}
