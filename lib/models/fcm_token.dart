import 'dart:io';

class FcmToken {
  final int id;
  final int userId;
  final String token;
  final DateTime createdAt;

 
  final String deviceType;

  FcmToken({
    required this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.deviceType,
  });

  factory FcmToken.fromJson(Map<String, dynamic> json) {
    return FcmToken(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId'].toString()) ?? 0,

      token: json['token'] ?? '',

      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),

      deviceType: json['deviceType'] ??
          (Platform.isIOS ? 'ios' : 'android'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'deviceType': deviceType,
    };
  }
}
