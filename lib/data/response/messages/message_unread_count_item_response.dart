class MessageUnreadCountItemResponse {
  final int unreadCount;

  MessageUnreadCountItemResponse({
    required this.unreadCount,
  });

  factory MessageUnreadCountItemResponse.fromJson(Map<String, dynamic> json) {
    return MessageUnreadCountItemResponse(
      unreadCount: json["unreadCount"] ?? 0,
    );
  }
}
