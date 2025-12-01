class NotificationUnreadSummaryItemResponse {
  final int totalUnread;
  final Map<String, int> byType;

  NotificationUnreadSummaryItemResponse({
    required this.totalUnread,
    required this.byType,
  });

  factory NotificationUnreadSummaryItemResponse.fromJson(
      Map<String, dynamic> json) {
    return NotificationUnreadSummaryItemResponse(
      totalUnread: json["totalUnread"] ?? 0,
      byType: (json["byType"] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                key,
                value is int ? value : 0,
              )),
    );
  }
}
