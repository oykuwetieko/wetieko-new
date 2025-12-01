import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/fcm_token_state_notifier.dart';
import 'package:Wetieko/screens/02_onboarding_screen/12_profile_photo_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/managers/notification_manager.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  Future<void> _handleNext(BuildContext context) async {
    final userNotifier = context.read<UserStateNotifier>();
    final fcmNotifier = Provider.of<FcmTokenStateNotifier>(context, listen: false);

    // 🔹 Her durumda FCM token oluştur
    await fcmNotifier.initFCM();

    // 🔸 Native bildirim izni iste
    await NotificationManager().initialize(requestPermission: true);

    // 🔸 İzin durumunu kontrol et
    final status = await Permission.notification.status;

    if (status.isGranted) {
      userNotifier.setNotificationPermission(true);
     
    } else {
      userNotifier.setNotificationPermission(false);
      
    }
    _goNext(context);
  }

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePhotoScreen(),
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
        currentStep: 9,
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
                  title: localizations.notificationPermissionTitle,
                  subtitle: localizations.notificationPermissionSubtitle,
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
