class MessageSendRequestDto {
  final int receiverId;
  final String content;

  MessageSendRequestDto({
    required this.receiverId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      "receiverId": receiverId,
      "content": content,
    };
  }
}
