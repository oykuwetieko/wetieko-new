class MessageAccessAcceptItemResponse {
  final int id;
  final int requesterId;
  final int receiverId;
  final DateTime createdAt;

  MessageAccessAcceptItemResponse({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.createdAt,
  });

  factory MessageAccessAcceptItemResponse.fromJson(
      Map<String, dynamic> json) {
    return MessageAccessAcceptItemResponse(
      id: json["id"] ?? 0,
      requesterId: json["requesterId"] ?? 0,
      receiverId: json["receiverId"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
