// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/profile_settings/profile_view_attributes.dart';
import 'package:Wetieko/widgets/profile_settings/profile_stats_card.dart';
import 'package:Wetieko/widgets/profile_settings/user_profile_header.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/states/follow_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/screens/07_chat_screen/02_chat_detail_screen.dart';
import 'package:Wetieko/states/profile_view_state_notifier.dart';
import 'package:Wetieko/widgets/common/block_button.dart';
import 'package:Wetieko/states/restriction_state_notifier.dart';

class ProfileViewScreen extends StatefulWidget {
  final User? externalUser;

  const ProfileViewScreen({super.key, this.externalUser});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  void initState() {
    super.initState();

    final followNotifier = context.read<FollowStateNotifier>();
    final currentUserId = context.read<UserStateNotifier>().state.user!.id;
    final viewedUserId = widget.externalUser?.id ?? currentUserId;

    debugPrint("📌 ProfileViewScreen INIT");
    debugPrint("🔎 viewedUserId = $viewedUserId");
    debugPrint("👤 currentUserId = $currentUserId");

    // 🔥 Engel durumu kontrolü
    if (widget.externalUser != null) {
      debugPrint("🚫 Engel durumu kontrol ediliyor → ${widget.externalUser!.id}");
      context.read<RestrictionStateNotifier>().checkUserRestriction(widget.externalUser!.id);
    }
    context.read<RestrictionStateNotifier>().fetchRestrictedUsers();

    // 🔥 Eğer başka birinin profiliyse
    if (widget.externalUser != null && widget.externalUser!.id != currentUserId) {
      debugPrint("👁 Profil görüntüleme kaydediliyor...");
      context.read<ProfileViewStateNotifier>().recordProfileView(viewedUserId);

      debugPrint("📩 FOLLOW STATUS FETCH çağrılıyor → $viewedUserId");
      followNotifier.fetchFollowStatus(viewedUserId);

      context.read<PlaceStateNotifier>().loadMyCheckIns(viewedUserId);
    } else {
      context.read<PlaceStateNotifier>().loadMyCheckIns(currentUserId);
    }
  }

  @override
  void dispose() {
    final currentUserId = context.read<UserStateNotifier>().state.user!.id;
    if (widget.externalUser != null && widget.externalUser!.id != currentUserId) {
      context.read<FollowStateNotifier>().fetchFollowersAndFollowing(currentUserId);
    }
    super.dispose();
  }

  Future<void> _handleChatTap(BuildContext context) async {
    if (widget.externalUser != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(externalUser: widget.externalUser!),
        ),
      );

      if (context.mounted) {
        context.read<RestrictionStateNotifier>().fetchRestrictedUsers();
        context.read<RestrictionStateNotifier>().checkUserRestriction(widget.externalUser!.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userState = context.watch<UserStateNotifier>().state;
    final currentUserId = userState.user!.id;
    final restrictionState = context.watch<RestrictionStateNotifier>();

    final isBlocked = restrictionState.isBlocked;
    final isOwnProfile =
        widget.externalUser == null || widget.externalUser!.id == currentUserId;

    final followNotifier = context.watch<FollowStateNotifier>();
    final followStatus = followNotifier.followStatus;
    final isLoadingFollow = followNotifier.isLoading;

    debugPrint("🎨 UI redraw → followStatus = $followStatus, isLoading = $isLoadingFollow");

    Widget _buildFollowButton() {
      String text;
      IconData icon;

      if (followStatus == "pending") {
        text = loc.pending;
        icon = Icons.hourglass_bottom;
      } else if (followStatus == "accepted") {
        text = loc.following;
        icon = Icons.check;
      } else {
        text = loc.follow;
        icon = Icons.person_add_alt_1;
      }

      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fabBackground,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: isLoadingFollow
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon),
        label: Text(text),
        onPressed: isLoadingFollow
            ? null
            : () {
                final viewedUserId = widget.externalUser!.id;

                debugPrint("👉 Follow button pressed → status = $followStatus");

                if (followStatus == "none" || followStatus == null) {
                  debugPrint("🚀 SEND FOLLOW REQUEST → $viewedUserId");
                  followNotifier.sendFollowRequest(viewedUserId);
                } else if (followStatus == "pending") {
                  debugPrint("⚠️ CANCEL FOLLOW REQUEST → $viewedUserId");
                  CustomAlert.show(
                    context,
                    title: loc.cancelFollowRequestTitle,
                    description: loc.cancelFollowRequestDescription,
                    icon: Icons.person_remove_alt_1_rounded,
                    confirmText: loc.cancelFollowRequestTitle,
                    cancelText: loc.cancel2,
                    isDestructive: true,
                    onConfirm: () {
                      followNotifier.cancelPendingRequest(viewedUserId);
                    },
                  );
                } else if (followStatus == "accepted") {
                  debugPrint("🧨 UNFOLLOW → $viewedUserId");
                  CustomAlert.show(
                    context,
                    title: loc.unfollowTitle,
                    description: loc.unfollowDescription,
                    icon: Icons.person_remove_alt_1_rounded,
                    confirmText: loc.unfollowTitle,
                    cancelText: loc.cancel2,
                    isDestructive: true,
                    onConfirm: () {
                      followNotifier.unfollow(viewedUserId);
                    },
                  );
                }
              },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.profileAbout,
        showStepBar: false,
        actionWidget: (!isOwnProfile)
            ? BlockButton(targetUser: widget.externalUser)
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            UserProfileHeader(
              showLabels: true,
              showEditButton: isOwnProfile,
              avatarClickable: isOwnProfile,
              externalUser: widget.externalUser,
            ),

            if (!isOwnProfile && !isBlocked)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(height: 40, child: _buildFollowButton()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _handleChatTap(context),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.fabBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.mark_unread_chat_alt,
                                  color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                loc.sendMessage,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ProfileStatsCard(
                enableSelection: false,
                showCounts: true,
                externalUserId: widget.externalUser?.id,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 40),
              child: widget.externalUser != null
                  ? ProfileViewAttributes(externalUser: widget.externalUser)
                  : ProfileViewAttributes(userState: userState),
            ),
          ],
        ),
      ),
    );
  }
}
