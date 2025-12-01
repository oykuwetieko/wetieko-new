import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> experienceLevelList(BuildContext context) => [
  AppLocalizations.of(context)!.junior,
  AppLocalizations.of(context)!.midLevel,
  AppLocalizations.of(context)!.senior,
  AppLocalizations.of(context)!.teamLead,
  AppLocalizations.of(context)!.manager,
  AppLocalizations.of(context)!.founder,
];
