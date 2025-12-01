class Subscription {
  final int id;
  final int userId;
  final String plan; // 'monthly' | 'yearly'
  final String platform; // 'ios' | 'android'
  final String providerProductId;
  final String? providerPurchaseToken;
  final String status; // 'active' | 'expired' | 'canceled' | 'trial'
  final DateTime startedAt;
  final DateTime expiresAt;
  final DateTime? canceledAt;
  final bool isAutoRenew;
  final DateTime lastVerificationAt;
  final DateTime createdAt;

  // Backend'de "updatedAt" yok → optional yaptık
  final DateTime? updatedAt;

  /// 🔹 Hesaplanmış alan: backend uppercase gönderirse bile çalışır
  bool get isActive =>
      status.toLowerCase() == 'active' &&
      expiresAt.isAfter(DateTime.now());

  int get remainingDays {
    final diff = expiresAt.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.platform,
    required this.providerProductId,
    this.providerPurchaseToken,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    this.canceledAt,
    required this.isAutoRenew,
    required this.lastVerificationAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['userId'] is int
          ? json['userId']
          : int.parse(json['userId'].toString()),
      plan: json['plan'] ?? '',
      platform: json['platform'] ?? '',
      providerProductId: json['providerProductId'] ?? '',
      providerPurchaseToken: json['providerPurchaseToken'],
      status: (json['status'] ?? '').toString().toLowerCase(),
      startedAt: DateTime.parse(json['startedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      canceledAt: json['canceledAt'] != null
          ? DateTime.parse(json['canceledAt'])
          : null,
      isAutoRenew: json['isAutoRenew'] ?? false,
      lastVerificationAt: DateTime.parse(json['lastVerificationAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': plan,
      'platform': platform,
      'providerProductId': providerProductId,
      'providerPurchaseToken': providerPurchaseToken,
      'status': status,
      'startedAt': startedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'canceledAt': canceledAt?.toIso8601String(),
      'isAutoRenew': isAutoRenew,
      'lastVerificationAt': lastVerificationAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
