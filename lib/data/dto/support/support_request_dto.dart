class SupportRequestDto {
  final String message;

  SupportRequestDto({required this.message});

  Map<String, dynamic> toJson() {
    return {
      "message": message,
    };
  }
}
