import 'dart:async';
import 'package:flutter/foundation.dart'; // debugPrint için
import 'package:signalr_netcore/signalr_client.dart';
import 'package:Wetieko/models/message_model.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';

class MessageSocketService {
  static final MessageSocketService _instance =
      MessageSocketService._internal();
  factory MessageSocketService() => _instance;
  MessageSocketService._internal();

  HubConnection? _hub;
  String? _registeredUserId;

  final _newMessageCtrl = StreamController<MessageModel>.broadcast();
  final _messageSentCtrl = StreamController<MessageModel>.broadcast();
  final _conversationListUpdatedCtrl =
      StreamController<List<MessageModel>>.broadcast();
  final _messagesReadByUserCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  final _unreadCountUpdatedCtrl = StreamController<int>.broadcast();

  final _accessAcceptedCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _restrictedCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _unrestrictedCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _messageDeletedCtrl = StreamController<String>.broadcast();

  Stream<MessageModel> get newMessageStream => _newMessageCtrl.stream;
  Stream<MessageModel> get messageSentStream => _messageSentCtrl.stream;
  Stream<List<MessageModel>> get conversationListUpdatedStream =>
      _conversationListUpdatedCtrl.stream;
  Stream<Map<String, dynamic>> get messagesReadByUserStream =>
      _messagesReadByUserCtrl.stream;
  Stream<int> get unreadCountUpdatedStream =>
      _unreadCountUpdatedCtrl.stream;

  Stream<Map<String, dynamic>> get accessAcceptedStream =>
      _accessAcceptedCtrl.stream;
  Stream<Map<String, dynamic>> get restrictedStream =>
      _restrictedCtrl.stream;
  Stream<Map<String, dynamic>> get unrestrictedStream =>
      _unrestrictedCtrl.stream;
  Stream<String> get messageDeletedStream =>
      _messageDeletedCtrl.stream;

  bool get isConnected =>
      _hub != null && _hub!.state == HubConnectionState.Connected;

  bool _conversationListListening = false;

  Map<String, dynamic> toStringKeyMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return {};
  }

  void enableConversationListListening(bool enable) {
    debugPrint("🔄 ConversationList Listening: $enable");
    _conversationListListening = enable;
  }

  /// CONNECT
  Future<void> connect(String baseUrl, String userId) async {
    if (isConnected) {
      debugPrint("⚠️ Hub zaten bağlı, tekrar bağlanılmadı.");
      return;
    }

    debugPrint("🌐 SignalR connect başlıyor → userId: $userId");

    final token = await TokenStorageService().getToken();
    final hubUrl = "$baseUrl/hubs/messages?userId=$userId";

    debugPrint("🔗 Hub URL: $hubUrl");

    _hub = HubConnectionBuilder()
        .withAutomaticReconnect()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token ?? "",
            transport: HttpTransportType.WebSockets,
          ),
        )
        .build();

    _bindEvents();

    try {
      debugPrint("🟡 Hub bağlantısı kuruluyor...");
      await _hub!.start();
      debugPrint("🟢 Hub bağlantısı başarılı!");

      debugPrint("🔐 register invoke gönderiliyor...");
      await _hub!.invoke("register", args: [userId]);

      _registeredUserId = userId;
      debugPrint("✅ Kullanıcı SignalR'a register edildi: $userId");
    } catch (e) {
      debugPrint("❌ SignalR bağlantı hatası: $e");
    }
  }

  /// EVENT LISTENERS
  void _bindEvents() {
    if (_hub == null) return;
    debugPrint("🔔 Event listeners bind ediliyor...");

    _hub!.on("newMessage", (data) {
      debugPrint("📩 Event: newMessage → $data");
      final raw = data?[0];
      if (raw is Map) {
        _newMessageCtrl.add(MessageModel.fromJson(toStringKeyMap(raw)));
      }
    });

    _hub!.on("messageSent", (data) {
      debugPrint("📤 Event: messageSent → $data");
      final raw = data?[0];
      if (raw is Map) {
        _messageSentCtrl.add(MessageModel.fromJson(toStringKeyMap(raw)));
      }
    });

    _hub!.on("conversationListUpdated", (data) {
      debugPrint("🗂 Event: conversationListUpdated → listening: $_conversationListListening | data: $data");
      if (!_conversationListListening) return;

      final raw = data?[0];
      if (raw is List) {
        final list = raw
            .map((e) => MessageModel.fromJson(toStringKeyMap(e)))
            .toList();
        _conversationListUpdatedCtrl.add(list);
      }
    });

    _hub!.on("messagesReadByUser", (data) {
      debugPrint("👁‍🗨 Event: messagesReadByUser → $data");
      final raw = data?[0];
      if (raw is Map) {
        _messagesReadByUserCtrl.add(toStringKeyMap(raw));
      }
    });

    _hub!.on("unreadCountUpdated", (data) {
      debugPrint("🔢 Event: unreadCountUpdated → $data");

      int? count;
      final raw = data?[0];

      if (raw is int) {
        count = raw;
      } else if (raw is String) {
        count = int.tryParse(raw);
      } else if (raw is Map) {
        final map = toStringKeyMap(raw);
        final v = map["count"] ?? map["unreadCount"];
        if (v is int) count = v;
        if (v is String) count = int.tryParse(v);
      }

      debugPrint("📊 unreadCount → $count");

      if (count != null) _unreadCountUpdatedCtrl.add(count);
    });

    _hub!.on("messageDeleted", (data) {
      debugPrint("🗑 Event: messageDeleted → $data");
      final raw = data?[0];
      if (raw is Map && raw["messageId"] != null) {
        _messageDeletedCtrl.add(raw["messageId"].toString());
      }
    });

    _hub!.on("accessAccepted", (data) {
      debugPrint("🟢 Event: accessAccepted → $data");
      final raw = data?[0];
      if (raw is Map) _accessAcceptedCtrl.add(toStringKeyMap(raw));
    });

    _hub!.on("userRestricted", (data) {
      debugPrint("🔴 Event: userRestricted → $data");
      final raw = data?[0];
      if (raw is Map) _restrictedCtrl.add(toStringKeyMap(raw));
    });

    _hub!.on("userUnrestricted", (data) {
      debugPrint("🟡 Event: userUnrestricted → $data");
      final raw = data?[0];
      if (raw is Map) _unrestrictedCtrl.add(toStringKeyMap(raw));
    });
  }

  /// MESAJ GÖNDERME
  Future<void> sendMessage(
      String senderId, String receiverId, String content) async {
    if (!isConnected) {
      debugPrint("❌ sendMessage çalışmadı → Hub bağlı değil!");
      return;
    }

    final payload = {
      "senderId": senderId,
      "dto": {
        "receiverId": int.parse(receiverId),
        "content": content,
      }
    };

    debugPrint("📨 sendMessage invoke → $payload");

    await _hub!.invoke("sendMessage", args: [payload]);
  }

  /// OKUNDU İŞARETLEME
  Future<void> markAsRead(String userId, String otherUserId) async {
    if (!isConnected) {
      debugPrint("❌ markAsRead çalışmadı → Hub bağlı değil!");
      return;
    }

    final payload = {
      "userId": userId,
      "otherUserId": otherUserId,
    };

    debugPrint("👁 markAsRead invoke → $payload");

    await _hub!.invoke("markAsRead", args: [payload]);
  }

  Future<void> disconnect() async {
    debugPrint("🔌 SignalR disconnect çağırıldı...");
    try {
      await _hub?.stop();
      debugPrint("🛑 Hub durduruldu.");
    } catch (e) {
      debugPrint("⚠️ disconnect hatası: $e");
    }

    _hub = null;
    _registeredUserId = null;
  }
}
