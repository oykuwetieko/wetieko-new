class MessageAccessRejectRequestDto {
  final int requestId;

  MessageAccessRejectRequestDto({required this.requestId});

  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
    };
  }
}
