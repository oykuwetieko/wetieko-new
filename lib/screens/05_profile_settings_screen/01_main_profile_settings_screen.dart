import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/profile_settings/user_profile_header.dart';
import 'package:Wetieko/widgets/profile_settings/profile_stats_card.dart';
import 'package:Wetieko/widgets/profile_settings/profile_settings_list.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/notification_buton.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/follow_state_notifier.dart';

class MainProfileSettingsScreen extends StatefulWidget {
  const MainProfileSettingsScreen({super.key});

  @override
  State<MainProfileSettingsScreen> createState() =>
      _MainProfileSettingsScreenState();
}

class _MainProfileSettingsScreenState
    extends State<MainProfileSettingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final userNotifier = context.read<UserStateNotifier>();
      final myUserId = userNotifier.state.user?.id;

      if (myUserId != null) {
        await context.read<PlaceStateNotifier>().loadMyCheckIns(myUserId);
        await context.read<PlaceStateNotifier>().loadMyFeedbacks();
        await context
            .read<FollowStateNotifier>()
            .fetchFollowersAndFollowing(myUserId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.profileSettings,
        showStepBar: false,
        actionWidget: const NotificationButton(), // ✅ güncellendi
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: const [
          UserProfileHeader(showLabels: true, showEditButton: true),
          SizedBox(height: 10),
          ProfileStatsCard(),
          SizedBox(height: 20),
          ProfileSettingsList(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
