import 'dart:convert';
import 'package:Wetieko/models/user_model.dart';

class AppNotification {
  final int id;                          // 🔥 String → int
  final String type;
  final String message;                  // 🔥 backend'de body
  final bool isRead;
  final DateTime createdAt;
  final User? sender;
  final Map<String, dynamic>? data;      // 🔥 backend string JSON → Map

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.sender,
    this.data,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      type: json['type'] ?? '',

      // 🔥 message backend'de yok → body kullan
      message: json['body'] ?? json['message'] ?? '',

      isRead: json['isRead'] ?? false,

      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),

      sender: json['sender'] != null
          ? User.fromJson(json['sender'])
          : null,

      // 🔥 data backend’de string JSON → Map’e çevir
      data: _parseData(json['data']),
    );
  }

  static Map<String, dynamic>? _parseData(dynamic raw) {
    if (raw == null) return null;

    if (raw is Map<String, dynamic>) return raw;

    if (raw is String && raw.startsWith('{')) {
      try {
        return jsonDecode(raw);
      } catch (_) {}
    }

    return null;
  }
}
