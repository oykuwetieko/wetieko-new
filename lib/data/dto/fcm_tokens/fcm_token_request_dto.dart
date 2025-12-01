class FcmTokenRequestDto {
  final String token;

  FcmTokenRequestDto({required this.token});

  Map<String, dynamic> toJson() {
    return {
      "token": token,
    };
  }
}
