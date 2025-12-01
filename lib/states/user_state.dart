import 'package:Wetieko/models/user_model.dart';

class UserState {
  final String? authProvider;
  final String? appleIdToken;
  final String? googleIdToken;

  final String? fullName;

  /// 🔥 Artık DateTime? (String değil)
  final DateTime? birthDate;

  final String? gender;

  final bool locationPermission;
  final String? city;
  final String? district;
  final double? latitude;
  final double? longitude;

  /// 🔔 Bildirim izni
  final bool notificationPermission;

  final List<String> usagePurposes;
  final List<String> sectors;
  final List<String> positions;
  final List<String> skills;
  final String? experienceLevel;
  final List<String> workEnvironments;

  final String? profileImage;
  final User? user;

  /// 🌐 Dil tercihi
  final String? language;

  /// 💎 Premium
  final bool isPremium;

  /// ⛔ Engelleme durumu
  final bool isBlockedByMe;

  const UserState({
    this.authProvider,
    this.appleIdToken,
    this.googleIdToken,
    this.fullName,
    this.birthDate,
    this.gender,
    this.locationPermission = false,
    this.city,
    this.district,
    this.latitude,
    this.longitude,
    this.notificationPermission = false,
    this.usagePurposes = const [],
    this.sectors = const [],
    this.positions = const [],
    this.skills = const [],
    this.experienceLevel,
    this.workEnvironments = const [],
    this.profileImage,
    this.user,
    this.language,
    this.isPremium = false,
    this.isBlockedByMe = false,
  });

  UserState copyWith({
    String? authProvider,
    String? appleIdToken,
    String? googleIdToken,
    String? fullName,

    /// 🔥 Burada da DateTime? olmalı
    DateTime? birthDate,

    String? gender,
    bool? locationPermission,
    String? city,
    String? district,
    double? latitude,
    double? longitude,
    bool? notificationPermission,
    List<String>? usagePurposes,
    List<String>? sectors,
    List<String>? positions,
    List<String>? skills,
    String? experienceLevel,
    List<String>? workEnvironments,
    String? profileImage,
    User? user,
    bool? isPremium,
    bool? isBlockedByMe,
    String? language,
  }) {
    return UserState(
      authProvider: authProvider ?? this.authProvider,
      appleIdToken: appleIdToken ?? this.appleIdToken,
      googleIdToken: googleIdToken ?? this.googleIdToken,
      fullName: fullName ?? this.fullName,

      /// 🔥 Artık DateTime merge ediyor
      birthDate: birthDate ?? this.birthDate,

      gender: gender ?? this.gender,
      locationPermission: locationPermission ?? this.locationPermission,
      city: city ?? this.city,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notificationPermission:
          notificationPermission ?? this.notificationPermission,
      usagePurposes: usagePurposes ?? this.usagePurposes,
      sectors: sectors ?? this.sectors,
      positions: positions ?? this.positions,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      workEnvironments: workEnvironments ?? this.workEnvironments,
      profileImage: profileImage ?? this.profileImage,
      user: user ?? this.user,
      isPremium: isPremium ?? this.isPremium,
      isBlockedByMe: isBlockedByMe ?? this.isBlockedByMe,
      language: language ?? this.language,
    );
  }
}
