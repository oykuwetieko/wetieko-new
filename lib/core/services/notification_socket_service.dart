import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';

class NotificationSocketService {
  static final NotificationSocketService _instance =
      NotificationSocketService._internal();
  factory NotificationSocketService() => _instance;
  NotificationSocketService._internal();

  HubConnection? _hub;

  final _unreadCountCtrl = StreamController<int>.broadcast();
  Stream<int> get unreadCountStream => _unreadCountCtrl.stream;

  bool get isConnected =>
      _hub != null && _hub!.state == HubConnectionState.Connected;

  Map<String, dynamic> toStringKeyMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return {};
  }

  Future<void> connect(String baseUrl, String userId) async {
    if (isConnected) return;

    final token = await TokenStorageService().getToken();
    final hubUrl = "$baseUrl/hubs/notifications?userId=$userId";

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
      await _hub!.start();
      await _hub!.invoke("register", args: [userId]);
    } catch (_) {}
  }

  void _bindEvents() {
    if (_hub == null) return;

    _hub!.on("notificationUnreadUpdated", (data) {
      int? count;
      final raw = data?[0];

      if (raw is int) {
        count = raw;
      } else if (raw is String) {
        count = int.tryParse(raw);
      } else if (raw is Map) {
        final map = toStringKeyMap(raw);
        final v = map["totalUnread"];
        if (v is int) count = v;
        if (v is String) count = int.tryParse(v);
      }

      if (count != null) {
        _unreadCountCtrl.add(count);
      }
    });
  }

  Future<void> disconnect() async {
    try {
      await _hub?.stop();
    } catch (_) {}

    _hub = null;
  }
}
