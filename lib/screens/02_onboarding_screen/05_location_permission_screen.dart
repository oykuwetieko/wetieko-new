import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';

import 'package:Wetieko/managers/location_manager.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/screens/02_onboarding_screen/06_usage_selection_screen.dart'; // ✅ Artık buraya geçiyor
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  Future<void> _handleNext(BuildContext context) async {
    final userState = context.read<UserStateNotifier>().state;

    // ✅ Eğer konum izni zaten verilmişse, tekrar isteme
    if (userState.locationPermission) {
      _goNext(context);
      return;
    }

    // ❌ İlk kez izin istiyoruz
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final location = await LocationManager.getLocation();

      if (location != null) {
        context.read<UserStateNotifier>().setLocationInfo(
              permission: true,
              city: location.city,
              district: location.district,
              latitude: location.latitude,
              longitude: location.longitude,
            );
      }
    } else {
      context.read<UserStateNotifier>().setLocationInfo(permission: false);
    }

    // 🔜 Artık doğrudan UsageSelectionScreen'e geçiyor
    _goNext(context);
  }

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsageSelectionScreen(), // ✅ Buraya yönlendiriyor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: const CustomAppBar(
        totalSteps: 10,
        currentStep: 2, // 👈 Onboarding adımı
        showStepBar: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/location_permission.png',
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                HeadingText(
                  title: localizations.shareLocation,
                  subtitle: localizations.locationHelpText,
                  align: TextAlign.left,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: localizations.continueButton,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.onboardingButtonText,
                  onPressed: () => _handleNext(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
