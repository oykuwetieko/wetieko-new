class MessageAccessAcceptRequestDto {
  final int requestId;

  MessageAccessAcceptRequestDto({required this.requestId});

  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
    };
  }
}
