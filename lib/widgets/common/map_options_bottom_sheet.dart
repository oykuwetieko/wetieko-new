import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapOptionsBottomSheet extends StatelessWidget {
  final Place place;

  const MapOptionsBottomSheet({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = AppColors.textFieldBorder.withOpacity(0.5);
    final loc = AppLocalizations.of(context)!;

    final mapOptions = <_MapOption>[
      if (Platform.isIOS)
        _MapOption(
          title: loc.openInAppleMaps,
          onTap: () => _launchAppleMaps(place),
        ),
      _MapOption(
        title: loc.openInGoogleMaps,
        onTap: () => _launchGoogleMaps(place),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.onboardingBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: AppColors.closeButtonIcon),
              ),
              Text(
                loc.openInMapTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.onboardingTitle,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 15),
          ...List.generate(mapOptions.length, (index) {
            final option = mapOptions[index];
            return Column(
              children: [
                ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  title: Center(
                    child: Text(
                      option.title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
                ),
                if (index < mapOptions.length - 1)
                  Divider(
                    color: dividerColor,
                    height: 1,
                    thickness: 1,
                  ),
              ],
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Future<void> _launchAppleMaps(Place place) async {
    final label = Uri.encodeComponent('${place.name}, ${place.formattedAddress}');
    final appleMapsUrl = Uri.parse('http://maps.apple.com/?ll=${place.lat},${place.lng}&q=$label');

    if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$label',
      );
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<void> _launchGoogleMaps(Place place) async {
    final label = Uri.encodeComponent('${place.name}, ${place.formattedAddress}');
    final fallbackUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$label',
    );

    if (Platform.isAndroid) {
      final appUrl = Uri.parse(
        'geo:${place.lat},${place.lng}?q=$label',
      );
      if (await canLaunchUrl(appUrl)) {
        await launchUrl(appUrl, mode: LaunchMode.externalApplication);
        return;
      }
    } else if (Platform.isIOS) {
      final appUrl = Uri.parse(
        'comgooglemaps://?q=$label&center=${place.lat},${place.lng}&zoom=17',
      );
      if (await canLaunchUrl(appUrl)) {
        await launchUrl(appUrl, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // fallback to browser
    if (await canLaunchUrl(fallbackUrl)) {
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    }
  }
}

class _MapOption {
  final String title;
  final VoidCallback onTap;
  _MapOption({required this.title, required this.onTap});
}
