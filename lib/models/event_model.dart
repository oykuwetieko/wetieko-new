import 'package:flutter/material.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/user_model.dart';

enum EventType { BIRLIKTE_CALIS, COWORK, ETKINLIK }

class ActivityTag {
  final IconData icon;
  final String label;
  final double value;

  ActivityTag({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class EventModel {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final int? maxParticipants;

  final bool hasSpeaker;
  final bool hasWorkshop;
  final bool hasCertificate;
  final bool isFree;
  final bool hasTreat;
  final bool hasRaffle;
  final bool hasGift;
  final bool isOutdoor;
  final bool hasSeatTable;
  final bool hasPhotoVideo;

  final DateTime createdAt;
  final User creator;
  final List<User> participants;
  final Place place;

  EventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.maxParticipants,
    required this.hasSpeaker,
    required this.hasWorkshop,
    required this.hasCertificate,
    required this.isFree,
    required this.hasTreat,
    required this.hasRaffle,
    required this.hasGift,
    required this.isOutdoor,
    required this.hasSeatTable,
    required this.hasPhotoVideo,
    required this.createdAt,
    required this.creator,
    required this.participants,
    required this.place,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"]?.toString() ?? "",
      type: _parseEventType(json["type"]),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: json["date"] ?? "",
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      maxParticipants: json["maxParticipants"],

      hasSpeaker: json["hasSpeaker"] ?? false,
      hasWorkshop: json["hasWorkshop"] ?? false,
      hasCertificate: json["hasCertificate"] ?? false,
      isFree: json["isFree"] ?? false,
      hasTreat: json["hasTreat"] ?? false,
      hasRaffle: json["hasRaffle"] ?? false,
      hasGift: json["hasGift"] ?? false,
      isOutdoor: json["isOutdoor"] ?? false,
      hasSeatTable: json["hasSeatTable"] ?? false,
      hasPhotoVideo: json["hasPhotoVideo"] ?? false,

      createdAt: _safeParseDate(json["createdAt"]),

      creator: json["creator"] != null
          ? User.fromJson({
              ...json["creator"],
              "id": json["creator"]["id"]?.toString()
            })
          : User.empty(),

      participants: (json["participants"] as List? ?? [])
          .map((e) => User.fromJson({
                ...e,
                "id": e["id"]?.toString(),
              }))
          .toList(),

      place: json["place"] != null
          ? Place.fromJson({
              ...json["place"],
              "id": json["place"]["id"]?.toString(),
            })
          : Place.empty(),
    );
  }

  static DateTime _safeParseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return DateTime.now();
  }

  static EventType _parseEventType(dynamic type) {
    if (type is String) {
      try {
        return EventType.values.byName(type);
      } catch (_) {}
    }
    return EventType.COWORK;
  }

  List<ActivityTag> get tags {
    final List<ActivityTag> list = [];

    if (hasSpeaker) {
      list.add(ActivityTag(icon: Icons.mic, label: 'Konuşmacı', value: 1.0));
    }
    if (hasWorkshop) {
      list.add(ActivityTag(icon: Icons.handyman, label: 'Atölye', value: 1.0));
    }
    if (hasCertificate) {
      list.add(ActivityTag(icon: Icons.badge, label: 'Sertifika', value: 1.0));
    }
    if (isFree) {
      list.add(ActivityTag(icon: Icons.money_off, label: 'Ücretsiz', value: 1.0));
    }
    if (hasTreat) {
      list.add(ActivityTag(icon: Icons.emoji_food_beverage, label: 'İkram', value: 1.0));
    }
    if (hasRaffle) {
      list.add(ActivityTag(icon: Icons.card_giftcard, label: 'Çekiliş', value: 1.0));
    }
    if (hasGift) {
      list.add(ActivityTag(icon: Icons.card_giftcard_outlined, label: 'Hediye', value: 1.0));
    }
    if (isOutdoor) {
      list.add(ActivityTag(icon: Icons.park, label: 'Açık Alan', value: 1.0));
    }
    if (hasSeatTable) {
      list.add(ActivityTag(icon: Icons.chair, label: 'Oturma Alanı', value: 1.0));
    }
    if (hasPhotoVideo) {
      list.add(ActivityTag(icon: Icons.photo_camera, label: 'Foto/Video', value: 1.0));
    }

    return list;
  }
}
