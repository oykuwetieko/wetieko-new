enum NotificationType {
  profileView,
  newFollower,
  newPlace,
  placeUpdate,
  newEvent,
  eventUpdate,
  general,
}

class NotificationModel {
  final NotificationType type;
  final String? imageUrl;
  final String? name;
  final String? address;
  final String? date;
  final String? from;
  final String? title;
  final String? subtitle;
  final String time;

  NotificationModel({
    required this.type,
    this.imageUrl,
    this.name,
    this.address,
    this.date,
    this.from,
    this.title,
    this.subtitle,
    required this.time,
  });
}
