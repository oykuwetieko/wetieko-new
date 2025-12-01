class PlaceAttendeesResponse {
  final bool isSuccess;
  final String? message;
  final List<PlaceAttendeeItem> data;
  final List<String>? errors;
  final String? errorCode;

  PlaceAttendeesResponse({
    required this.isSuccess,
    this.message,
    required this.data,
    this.errors,
    this.errorCode,
  });

  factory PlaceAttendeesResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAttendeesResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PlaceAttendeeItem.fromJson(e))
          .toList(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      errorCode: json['errorCode'],
    );
  }
}

class PlaceAttendeeItem {
  final int userId;
  final String name;
  final String? profileImage;
  final String? careerPosition;
  final DateTime checkInAt;

  PlaceAttendeeItem({
    required this.userId,
    required this.name,
    this.profileImage,
    this.careerPosition,
    required this.checkInAt,
  });

  factory PlaceAttendeeItem.fromJson(Map<String, dynamic> json) {
    return PlaceAttendeeItem(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      careerPosition: json['careerPosition'],
      checkInAt: DateTime.tryParse(json['checkInAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
