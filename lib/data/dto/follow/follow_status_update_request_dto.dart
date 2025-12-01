class FollowStatusUpdateRequestDto {
  final String status;

  FollowStatusUpdateRequestDto({required this.status});

  Map<String, dynamic> toJson() {
    return {
      "status": status,
    };
  }
}
