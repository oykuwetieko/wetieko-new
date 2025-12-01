import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/02_profile_edit_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/03_favorite_places_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/08_language_settings_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/10_privacy_policy_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/11_terms_use_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/14_my_place_preferences_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/15_restricted_users_screen.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/screens/01_welcome_screen/01_welcome_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/widgets/profile_settings/feedback_dropdown.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'package:Wetieko/managers/notification_permission_helper.dart';
import 'package:Wetieko/managers/location_permission_helper.dart';
import 'package:Wetieko/states/fcm_token_state_notifier.dart'; 

class ProfileSettingsList extends StatefulWidget {
  const ProfileSettingsList({super.key});

  @override
  State<ProfileSettingsList> createState() => _ProfileSettingsListState();
}

class _ProfileSettingsListState extends State<ProfileSettingsList>
    with WidgetsBindingObserver {
  bool _notificationEnabled = false;
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🔁 Uygulama ön plana gelince izinleri yeniden kontrol et
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPermissions();
    }
  }

 Future<void> _loadPermissions() async {
  final notifGranted = await NotificationPermissionHelper.getActualNotificationStatus();
  final locGranted = await LocationPermissionHelper.getActualLocationStatus();

  if (!mounted) return;

  setState(() {
    _notificationEnabled = notifGranted;
    _locationEnabled = locGranted;
  });

  final userNotifier = context.read<UserStateNotifier>();
  userNotifier.setNotificationPermission(notifGranted);
  userNotifier.setLocationInfo(permission: locGranted);

  // ✅ Eğer kullanıcı daha önce izin vermemişti ama şimdi verdiyse FCM kaydet
  if (notifGranted) {
    final fcmNotifier = Provider.of<FcmTokenStateNotifier>(context, listen: false);
    await fcmNotifier.initFCM();
    debugPrint("✅ FCM token yeniden oluşturuldu (izin sonradan verildi).");
  }
}



  Future<void> _toggleNotification(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      final granted = status.isGranted;
      setState(() => _notificationEnabled = granted);
      context.read<UserStateNotifier>().setNotificationPermission(granted);
      if (!granted) await openAppSettings();
    } else {
      await openAppSettings();
    }
  }

  Future<void> _toggleLocation(bool value) async {
    if (value) {
      final status = await Permission.location.request();
      final granted = status.isGranted;
      setState(() => _locationEnabled = granted);
      context.read<UserStateNotifier>().setLocationInfo(permission: granted);
      if (!granted) await openAppSettings();
    } else {
      await openAppSettings();
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.categoryActive,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.categoryActive,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTileSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 20, color: AppColors.closeButtonIcon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.neutralDark,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.categoryActive,
        ),
      ),
    );
  }

  Widget _cardTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 20, color: AppColors.closeButtonIcon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.neutralDark,
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            size: 20, color: AppColors.categoryInactiveText),
        onTap: onTap,
      ),
    );
  }

  Widget _dangerActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(fontSize: 12, color: color)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userNotifier = context.read<UserStateNotifier>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(loc.preferences),

        _cardTile(
          icon: Icons.person_outline,
          title: loc.accountSettings,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()));
          },
        ),

      _cardTileSwitch(
  icon: Icons.notifications_none,
  title: loc.notificationPermission,
  value: _notificationEnabled,
  onChanged: (v) => _toggleNotification(v),
),

_cardTileSwitch(
  icon: Icons.location_on_outlined,
  title: loc.locationPermission,
  value: _locationEnabled,
  onChanged: (v) => _toggleLocation(v),
),

        _cardTile(
          icon: Icons.language,
          title: loc.appLanguage,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()));
          },
        ),

        _cardTile(
          icon: Icons.block_outlined,
          title: loc.restrictedUsers,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RestrictedUsersScreen()));
          },
        ),

        _sectionTitle(loc.interactions),
        _cardTile(
          icon: Icons.store_outlined,
          title: loc.placePreferences,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MyPlacePreferencesScreen()));
          },
        ),
        _cardTile(
          icon: Icons.favorite_border,
          title: loc.favoritePlaces,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoritePlacesScreen()));
          },
        ),
        _cardTile(
          icon: Icons.history,
          title: loc.eventHistory,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) =>
                    const MainNavigationWrapper(initialIndex: 3)));
          },
        ),

        _sectionTitle(loc.helpAndFeedback),
        _cardTile(
          icon: Icons.feedback_outlined,
          title: loc.sendFeedback,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: GestureDetector(
                    onTap: () {},
                    child: FeedbackDropDown(
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
            );
          },
        ),
        _cardTile(
          icon: Icons.star_border,
          title: loc.rateApp,
          onTap: () {},
        ),

        _sectionTitle(loc.agreements),
        _cardTile(
          icon: Icons.privacy_tip_outlined,
          title: loc.privacyPolicy,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
          },
        ),
        _cardTile(
          icon: Icons.article_outlined,
          title: loc.termsOfUse,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TermsUseScreen()));
          },
        ),

        _sectionTitle(loc.dangerZone),
        _dangerActionCard(
          icon: Icons.delete_forever,
          title: loc.deleteAccount,
          subtitle: loc.deleteAccountSubtitle,
          color: Colors.red,
          onTap: () {
            CustomAlert.show(
              context,
              title: loc.deleteAccountTitle,
              description: loc.deleteAccountDescription,
              icon: Icons.delete_forever_rounded,
              confirmText: loc.delete,
              cancelText: loc.cancel,
              isDestructive: true,
              onConfirm: () async {
                try {
                 await userNotifier.userRepo.remote.deleteAccount();

                  await TokenStorageService().deleteToken();
                  await TokenStorageService().clearAll();
                  userNotifier.reset();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (_) => false,
                  );
                } catch (e) {
                  debugPrint("❌ Hesap silinirken hata: $e");
                }
              },
              onCancel: () {},
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
