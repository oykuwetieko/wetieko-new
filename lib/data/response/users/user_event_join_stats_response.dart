class UserEventJoinStatsResponse {
  final bool isSuccess;
  final String message;
  final UserEventJoinStatsData? data;
  final List<String>? errors;
  final String? errorCode;

  UserEventJoinStatsResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory UserEventJoinStatsResponse.fromJson(Map<String, dynamic> json) {
    return UserEventJoinStatsResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UserEventJoinStatsData.fromJson(json['data'])
          : null,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : null,
      errorCode: json['errorCode'],
    );
  }
}

class UserEventJoinStatsData {
  final int birlikteCalis;
  final int cowork;
  final int etkinlik;

  UserEventJoinStatsData({
    required this.birlikteCalis,
    required this.cowork,
    required this.etkinlik,
  });

  factory UserEventJoinStatsData.fromJson(Map<String, dynamic> json) {
    return UserEventJoinStatsData(
      birlikteCalis: json['birlikteCalis'] ?? 0,
      cowork: json['cowork'] ?? 0,
      etkinlik: json['etkinlik'] ?? 0,
    );
  }
}
