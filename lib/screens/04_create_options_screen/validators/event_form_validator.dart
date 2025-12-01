import 'package:flutter/material.dart';
import 'package:Wetieko/models/event_model.dart'; 

class EventFormValidator {

  static bool isTitleInvalid(String title) {
    final trimmed = title.trim();
    return trimmed.length < 5 || trimmed.length > 25;
  }

  static bool isDescriptionInvalid(String description) {
    final trimmed = description.trim();
    return trimmed.length < 5 || trimmed.length > 300;
  }

  static bool isLocationInvalid(String locationText, String? placeId) {
    return locationText.trim().isEmpty || placeId == null;
  }

  static bool isParticipantInvalid({
    required EventType type,
    required int? selectedParticipant,
    required String participantText,
  }) {
    final requiresParticipant =
        type == EventType.COWORK || type == EventType.ETKINLIK;

    final isTextEmpty = participantText.trim().isEmpty;

    return requiresParticipant &&
        selectedParticipant == null &&
        isTextEmpty;
  }

static void handleTitleInputLimit(TextEditingController controller) {
  final text = controller.text;
  if (text.trim().length > 25) {


  }
}

static void handleDescriptionInputLimit(TextEditingController controller) {
  final text = controller.text;
  if (text.trim().length > 300) {
   
  }
}

  static String? getValidationError({
    required EventType type,
    required String title,
    required String description,
    required String locationText,
    required String? placeId,
    required int? selectedParticipant,
    required String participantText,
  }) {
    if (isTitleInvalid(title)) return 'invalidTitle';
    if (isDescriptionInvalid(description)) return 'invalidDescription';
    if (isLocationInvalid(locationText, placeId)) return 'invalidLocation';
    if (isParticipantInvalid(
        type: type,
        selectedParticipant: selectedParticipant,
        participantText: participantText)) {
      return 'invalidParticipant';
    }
    return null;
  }
}
