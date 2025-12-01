class FollowStatusItemResponse {
  final String status;

  FollowStatusItemResponse({required this.status});

  factory FollowStatusItemResponse.fromJson(Map<String, dynamic> json) {
    return FollowStatusItemResponse(
      status: json["status"] ?? "",
    );
  }
}
