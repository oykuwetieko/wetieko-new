import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> environmentList(BuildContext context) => [
  AppLocalizations.of(context)!.quietLibrary,
  AppLocalizations.of(context)!.coffeeShop,
  AppLocalizations.of(context)!.highEnergyCoworking,
  AppLocalizations.of(context)!.office,
  AppLocalizations.of(context)!.openAir,
  AppLocalizations.of(context)!.doesNotMatter,
];
