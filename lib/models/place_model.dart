import 'package:flutter/material.dart';
import 'package:Wetieko/models/feedback_model.dart' as fb;

enum PlaceTagCategory {
  workingConditions,
  spaceFeatures,
}

class PlaceTag {
  final IconData icon;
  final String label;
  final double value;
  final PlaceTagCategory category;

  PlaceTag({
    required this.icon,
    required this.label,
    required this.value,
    required this.category,
  });
}

class Place {
  final String id;
  final String placeId;
  final String name;
  final String? formattedAddress;

  final double lat;
  final double lng;

  final String? city;
  final String? district;
  final int? priceLevel;
  final double? rating;

  final DateTime createdAt;

  final double? avgWifi;
  final double? avgSocket;
  final double? avgNoiseLevel;
  final double? avgWorkDesk;
  final double? avgVentilation;
  final double? avgLighting;

  final bool? hasMeetingArea;
  final bool? hasOutdoorArea;
  final bool? hasParking;
  final bool? hasView;
  final bool? isPetFriendly;

  final List<fb.PlaceFeedback>? feedbacks;

  final int? feedbackCount;

  final List<String> weekdayText;
  final List<String> photoReferences;

  Place({
    required this.id,
    required this.placeId,
    required this.name,
    this.formattedAddress,
    required this.lat,
    required this.lng,
    this.city,
    this.district,
    this.priceLevel,
    this.rating,
    required this.createdAt,
    this.avgWifi,
    this.avgSocket,
    this.avgNoiseLevel,
    this.avgWorkDesk,
    this.avgVentilation,
    this.avgLighting,
    this.hasMeetingArea,
    this.hasOutdoorArea,
    this.hasParking,
    this.hasView,
    this.isPetFriendly,
    this.feedbacks,
    this.feedbackCount,
    required this.weekdayText,
    required this.photoReferences,
  });

  // ==========================
  // TAG GETTERS
  // ==========================

  List<PlaceTag> get workingConditionTags {
    return [
      if (avgWifi != null)
        PlaceTag(
            icon: Icons.wifi,
            label: 'Wifi',
            value: avgWifi!,
            category: PlaceTagCategory.workingConditions),
      if (avgSocket != null)
        PlaceTag(
            icon: Icons.power,
            label: 'Priz',
            value: avgSocket!,
            category: PlaceTagCategory.workingConditions),
      if (avgNoiseLevel != null)
        PlaceTag(
            icon: Icons.timer,
            label: 'Sessizlik',
            value: avgNoiseLevel!,
            category: PlaceTagCategory.workingConditions),
      if (avgWorkDesk != null)
        PlaceTag(
            icon: Icons.table_bar,
            label: 'Çalışma Masası',
            value: avgWorkDesk!,
            category: PlaceTagCategory.workingConditions),
      if (avgVentilation != null)
        PlaceTag(
            icon: Icons.ac_unit,
            label: 'Havalandırma',
            value: avgVentilation!,
            category: PlaceTagCategory.workingConditions),
      if (avgLighting != null)
        PlaceTag(
            icon: Icons.light_mode,
            label: 'Aydınlatma',
            value: avgLighting!,
            category: PlaceTagCategory.workingConditions),
    ];
  }

  List<PlaceTag> get spaceFeatureTags {
    return [
      if (hasMeetingArea == true)
        PlaceTag(
            icon: Icons.people_alt,
            label: 'Toplantıya Uygun',
            value: 1.0,
            category: PlaceTagCategory.spaceFeatures),
      if (hasOutdoorArea == true)
        PlaceTag(
            icon: Icons.park,
            label: 'Açık Alan / Teras',
            value: 1.0,
            category: PlaceTagCategory.spaceFeatures),
      if (isPetFriendly == true)
        PlaceTag(
            icon: Icons.pets,
            label: 'Hayvan Dostu',
            value: 1.0,
            category: PlaceTagCategory.spaceFeatures),
      if (hasParking == true)
        PlaceTag(
            icon: Icons.local_parking,
            label: 'Park Yeri',
            value: 1.0,
            category: PlaceTagCategory.spaceFeatures),
      if (hasView == true)
        PlaceTag(
            icon: Icons.landscape,
            label: 'Manzara',
            value: 1.0,
            category: PlaceTagCategory.spaceFeatures),
    ];
  }

  // ==========================
  // FROM JSON (GÜVENLİ)
  // ==========================

  factory Place.fromJson(Map<String, dynamic> json) {
    final summary = json['feedbackSummary'];
    final avg = summary?['avg'];
    final features = summary?['features'];

    return Place(
      id: json['id']?.toString() ?? '',
      placeId: json['placeId']?.toString() ?? '',
      name: json['name'] ?? '',
      formattedAddress: json['formattedAddress'],
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      city: json['city'],
      district: json['district'],
      priceLevel: json['priceLevel'],
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      avgWifi:
          (avg?['wifi'] as num?)?.toDouble() ?? (json['avgWifi'] as num?)?.toDouble(),
      avgSocket:
          (avg?['socket'] as num?)?.toDouble() ?? (json['avgSocket'] as num?)?.toDouble(),
      avgNoiseLevel:
          (avg?['noise'] as num?)?.toDouble() ?? (json['avgNoiseLevel'] as num?)?.toDouble(),
      avgWorkDesk:
          (avg?['desk'] as num?)?.toDouble() ?? (json['avgWorkDesk'] as num?)?.toDouble(),
      avgVentilation:
          (avg?['ventilation'] as num?)?.toDouble() ?? (json['avgVentilation'] as num?)?.toDouble(),
      avgLighting:
          (avg?['lighting'] as num?)?.toDouble() ?? (json['avgLighting'] as num?)?.toDouble(),

      hasMeetingArea: features?['hasMeetingArea'] ??
          features?['meetingFriendly'] ??
          json['hasMeetingArea'],
      hasOutdoorArea: features?['hasOutdoorArea'] ??
          features?['openArea'] ??
          json['hasOutdoorArea'],
      isPetFriendly: features?['isPetFriendly'] ??
          features?['petFriendly'] ??
          json['isPetFriendly'],
      hasParking: features?['hasParking'] ?? json['hasParking'],
      hasView: features?['hasView'] ?? json['hasView'],

      feedbacks: (json['feedbacks'] is List)
          ? (json['feedbacks'] as List)
              .map((e) => fb.PlaceFeedback.fromJson(e))
              .toList()
          : [],

      feedbackCount: summary?['total'] ?? json['feedbackCount'],

      // ***********************
      // SAFE PARSING HERE 🔥🔥🔥
      // ***********************
      weekdayText: json['weekdayText'] is List
          ? List<String>.from(json['weekdayText'])
          : [],

      photoReferences: json['photoReferences'] is List
          ? List<String>.from(json['photoReferences'])
          : [],
    );
  }

  // ==========================
  // TO JSON
  // ==========================

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "placeId": placeId,
      "name": name,
      "formattedAddress": formattedAddress,
      "lat": lat,
      "lng": lng,
      "city": city,
      "district": district,
      "priceLevel": priceLevel,
      "rating": rating,
      "createdAt": createdAt.toIso8601String(),
      "avgWifi": avgWifi,
      "avgSocket": avgSocket,
      "avgNoiseLevel": avgNoiseLevel,
      "avgWorkDesk": avgWorkDesk,
      "avgVentilation": avgVentilation,
      "avgLighting": avgLighting,
      "hasMeetingArea": hasMeetingArea,
      "hasOutdoorArea": hasOutdoorArea,
      "hasParking": hasParking,
      "hasView": hasView,
      "isPetFriendly": isPetFriendly,
      "weekdayText": weekdayText,
      "photoReferences": photoReferences,
    };
  }

  factory Place.empty() {
    return Place(
      id: '',
      placeId: '',
      name: '',
      formattedAddress: null,
      lat: 0.0,
      lng: 0.0,
      city: null,
      district: null,
      priceLevel: null,
      rating: null,
      createdAt: DateTime.now(),
      avgWifi: null,
      avgSocket: null,
      avgNoiseLevel: null,
      avgWorkDesk: null,
      avgVentilation: null,
      avgLighting: null,
      hasMeetingArea: null,
      hasOutdoorArea: null,
      hasParking: null,
      hasView: null,
      isPetFriendly: null,
      feedbacks: null,
      feedbackCount: 0,
      weekdayText: const [],
      photoReferences: const [],
    );
  }
}
