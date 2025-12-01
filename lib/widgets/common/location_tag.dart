import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/city_drop_down.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/data/constants/city_list.dart'; // ✅ cityList için import

class LocationTag extends StatefulWidget {
  const LocationTag({super.key});

  @override
  State<LocationTag> createState() => _LocationTagState();
}

class _LocationTagState extends State<LocationTag> {
  String? _selectedCity;

  void _showCityPicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "CityPicker",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CityDropDown(
                    onSelectCity: (selectedCity) async {
                      setState(() {
                        _selectedCity = selectedCity;
                      });

                      final userNotifier = context.read<UserStateNotifier>();
                      userNotifier.setLocationInfo(
                        permission: true,
                        city: selectedCity,
                      );

                      final placeNotifier = context.read<PlaceStateNotifier>();
                      try {
                        await placeNotifier.loadPlaces(city: selectedCity);
                      } catch (e) {
                        // hata ignore edildi
                      }

                      Navigator.of(context).pop();
                    },
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cityFromState = context.watch<UserStateNotifier>().state.city;

    // ✅ cityList içinde yoksa İstanbul göster
    final displayedCity = _selectedCity ??
        (cityFromState != null && cityList.contains(cityFromState)
            ? cityFromState
            : 'İstanbul');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.currentLocation,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.neutralGrey,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _showCityPicker,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.neutralGrey,
              ),
              const SizedBox(width: 4),
              Text(
                displayedCity,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutralGrey,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.expand_more,
                size: 20,
                color: AppColors.neutralGrey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
