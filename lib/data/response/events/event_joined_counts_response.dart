class EventJoinedCountsResponse {
  final bool isSuccess;
  final String? message;
  final EventJoinedCountsData? data;
  final List<String>? errors;
  final String? errorCode;

  EventJoinedCountsResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.errors,
    this.errorCode,
  });

  factory EventJoinedCountsResponse.fromJson(Map<String, dynamic> json) {
    return EventJoinedCountsResponse(
      isSuccess: json["isSuccess"] ?? false,
      message: json["message"],
      data: json["data"] != null && json["data"] is Map
          ? EventJoinedCountsData.fromJson(json["data"])
          : null,
      errors: (json["errors"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json["errorCode"],
    );
  }
}

class EventJoinedCountsData {
  final int birlikteCalis;
  final int cowork;
  final int etkinlik;

  EventJoinedCountsData({
    required this.birlikteCalis,
    required this.cowork,
    required this.etkinlik,
  });

  factory EventJoinedCountsData.fromJson(Map<String, dynamic> json) {
    return EventJoinedCountsData(
      birlikteCalis: json["birlikteCalis"] ?? 0,
      cowork: json["cowork"] ?? 0,
      etkinlik: json["etkinlik"] ?? 0,
    );
  }
}
