import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/profile_settings/follower_following_segment.dart';
import 'package:Wetieko/widgets/profile_settings/connection_card.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';

import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/follow_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/models/user_model.dart';

class MyConnectionScreen extends StatefulWidget {
  final int initialTabIndex;
  final String? externalUserId;
  final bool readOnly;

  const MyConnectionScreen({
    super.key,
    this.initialTabIndex = 0,
    this.externalUserId,
    this.readOnly = false,
  });

  @override
  State<MyConnectionScreen> createState() => _MyConnectionScreenState();
}

class _MyConnectionScreenState extends State<MyConnectionScreen> {
  late int selectedIndex;
  late String viewedUserId;
  late bool isOwnProfileView;

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.initialTabIndex;

    final myUserId = context.read<UserStateNotifier>().state.user!.id;
    viewedUserId = widget.externalUserId ?? myUserId;

    isOwnProfileView =
        widget.externalUserId == null || widget.externalUserId == myUserId;

    context.read<FollowStateNotifier>().fetchFollowersAndFollowing(viewedUserId);
  }

  // ------------------------------------------------------------
  // careerPosition → String normalizasyonu
  // ------------------------------------------------------------
  String _normalizeCareer(dynamic careerPosition) {
    if (careerPosition == null) return "";
    if (careerPosition is String) return careerPosition;
    if (careerPosition is List) {
      return careerPosition.whereType<String>().join(", ");
    }
    return careerPosition.toString();
  }

  Future<void> _confirmAndRemoveFollower(
  BuildContext context,
  String followerUserId,
) async {
  final loc = AppLocalizations.of(context)!;

  CustomAlert.show(
    context,
    title: loc.removeFollowerTitle,
    description: loc.removeFollowerDescription,
    icon: Icons.person_remove_alt_1_rounded,
    confirmText: loc.removeFollowerTitle,
    cancelText: loc.cancel2,
    isDestructive: true,
    onConfirm: () async {
      await context.read<FollowStateNotifier>().removeFollower(followerUserId);

      if (!mounted) return;

      await context
          .read<FollowStateNotifier>()
          .fetchFollowersAndFollowing(viewedUserId);
    },
    onCancel: () {}, // 🔥 İPTAL butonu için eklendi
  );
}


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.myConnections,
        showStepBar: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FollowerFollowingSegment(
              initialSelection: selectedIndex,
              onTabChanged: (index) => setState(() => selectedIndex = index),
            ),

            Expanded(
              child: Consumer<FollowStateNotifier>(
                builder: (context, followState, _) {
                  final isFollowersTab = selectedIndex == 0;

                  final list =
                      isFollowersTab ? followState.followers : followState.following;

                  // 🎯 Boş liste durumları
                  if (list.isEmpty) {
                    return Center(
                      child: EmptyStateWidget(
                        type: isOwnProfileView
                            ? (isFollowersTab
                                ? EmptyStateType.noFollowers
                                : EmptyStateType.noFollowing)
                            : EmptyStateType.noData,
                      ),
                    );
                  }

                  return ListView(
                    children: list.map((f) {
                      // 🔥 Kullanıcıyı null’dan koru
                      final rawUser = isFollowersTab ? f.follower : f.following;
                      final user = rawUser ?? User.empty();

                      return ConnectionCard(
                        imagePath: (user.profileImage?.isNotEmpty ?? false)
                            ? user.profileImage!
                            : "assets/default_avatar.png",
                        name: user.name ?? '',
                        profession: _normalizeCareer(user.careerPosition),
                        city: user.location ?? "",
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProfileViewScreen(externalUser: user),
                            ),
                          );

                          if (!mounted) return;
                          await context
                              .read<FollowStateNotifier>()
                              .fetchFollowersAndFollowing(viewedUserId);
                        },

                        // ❌ sadece takipçi tabında ve kendi profilimde görünür
                        onRemove: (isFollowersTab &&
                                isOwnProfileView &&
                                !widget.readOnly)
                            ? () => _confirmAndRemoveFollower(context, user.id)
                            : null,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
