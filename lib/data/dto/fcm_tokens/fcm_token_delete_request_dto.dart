class FcmTokenDeleteRequestDto {
  final String token;

  FcmTokenDeleteRequestDto({required this.token});

  Map<String, dynamic> toJson() {
    return {
      "token": token,
    };
  }
}
