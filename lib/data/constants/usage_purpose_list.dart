import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

List<String> usagePurposeList(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  return [
    t.expandNetwork,
    t.mentorshipIntent,
    t.findCoworker,
    t.joinSocialEvents,
    t.exploreCoworkingSpaces,
    t.meetNewPeople,
    t.findProjectPartner,
  ];
}