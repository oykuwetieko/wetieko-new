class MessageMarkAsReadRequestDto {
  final int otherUserId;

  MessageMarkAsReadRequestDto({required this.otherUserId});

  Map<String, dynamic> toJson() {
    return {
      "otherUserId": otherUserId,
    };
  }
}
