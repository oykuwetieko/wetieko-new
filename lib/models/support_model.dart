class Support {
  final String message;

  Support({
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      message: json['message'] ?? '',
    );
  }
}
