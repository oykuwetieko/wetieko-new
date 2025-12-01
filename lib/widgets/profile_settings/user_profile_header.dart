import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/profile_avatar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/02_profile_edit_screen.dart';
import 'package:Wetieko/widgets/profile_settings/edit_profile_button.dart';
import 'package:Wetieko/widgets/common/photo_picker_sheet.dart';
import 'package:Wetieko/managers/photo_manager.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/follow_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/states/subscription_state_notifier.dart';
import 'package:Wetieko/widgets/premium/become_premium_badge.dart';
import 'package:Wetieko/widgets/common/image_preview_viewer.dart';

import 'package:Wetieko/screens/05_profile_settings_screen/09_my_connection_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/13_my_place_reviews.dart';

class UserProfileHeader extends StatefulWidget {
  final bool showLabels;
  final bool showEditButton;
  final bool avatarClickable;
  final User? externalUser;

  const UserProfileHeader({
    super.key,
    this.showLabels = true,
    this.showEditButton = true,
    this.avatarClickable = false,
    this.externalUser,
  });

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

enum _ProfileImageAction { added, changed, deleted }

class _UserProfileHeaderState extends State<UserProfileHeader> {
  final PhotoManager _photoManager = PhotoManager();
  File? _profileImage;
  int? externalCommentCount;
  bool _isLoading = false;

  bool _forcePlaceholder = false;
  int _imageVersion = 0;

  @override
  void initState() {
    super.initState();
    _fetchExternalFeedbackCountIfNeeded();
  }

  void _fetchExternalFeedbackCountIfNeeded() async {
    if (widget.externalUser != null) {
      final placeState = context.read<PlaceStateNotifier>();
      final feedbacks =
          await placeState.loadFeedbacksByUser(widget.externalUser!.id);
      setState(() => externalCommentCount = feedbacks.length);
    }
  }

  Future<void> _handleProfileImageUpdate(
      File? file, _ProfileImageAction action) async {
    final userNotifier = context.read<UserStateNotifier>();
    setState(() => _isLoading = true);

    try {
      await userNotifier.updateProfileImage(file);

      setState(() {
        _profileImage = file;
        _forcePlaceholder = (action == _ProfileImageAction.deleted);
        _imageVersion++;
        _isLoading = false;
      });

      final loc = AppLocalizations.of(context)!;
      final title = loc.profileImageUpdated;

      late final String message;
      switch (action) {
        case _ProfileImageAction.added:
          message = loc.profileImageAdded;
          break;
        case _ProfileImageAction.changed:
          message = loc.profileImageChanged;
          break;
        case _ProfileImageAction.deleted:
          message = loc.profileImageDeleted;
          break;
      }

      CustomAlert.show(
        context,
        title: title,
        description: message,
        icon: Icons.check_circle_rounded,
        confirmText: loc.ok,
        onConfirm: () {},
      );
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _openPhotoPickerSheet(BuildContext context) {
    final userNotifier = context.read<UserStateNotifier>();
    final hasImageBefore =
        (_profileImage != null) ||
            (userNotifier.state.user?.profileImage?.isNotEmpty == true);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return PhotoPickerSheet(
          onPickGallery: () async {
            Navigator.pop(context);
            final file = await _photoManager.pickFromGallery();
            if (file != null) {
              await _handleProfileImageUpdate(
                  file,
                  hasImageBefore
                      ? _ProfileImageAction.changed
                      : _ProfileImageAction.added);
            }
          },
          onPickCamera: () async {
            Navigator.pop(context);
            final file = await _photoManager.pickFromCamera();
            if (file != null) {
              await _handleProfileImageUpdate(
                  file,
                  hasImageBefore
                      ? _ProfileImageAction.changed
                      : _ProfileImageAction.added);
            }
          },
          onDelete: () async {
            Navigator.pop(context);
            await _handleProfileImageUpdate(
                null, _ProfileImageAction.deleted);
          },
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  String? _effectiveProfileImagePath(User user) {
    if (_forcePlaceholder) return null;

    final base = _profileImage != null
        ? _profileImage!.path
        : (user.profileImage?.isNotEmpty == true
            ? user.profileImage!
            : null);

    if (base == null) return null;

    if (base.startsWith('http')) {
      final sep = base.contains('?') ? '&' : '?';
      return '$base${sep}v=$_imageVersion';
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userState = context.watch<UserStateNotifier>().state;
    final placeState = context.watch<PlaceStateNotifier>();
    final followState = context.watch<FollowStateNotifier>();
    final subscriptionState = context.watch<SubscriptionStateNotifier>();

    final user = widget.externalUser ?? userState.user;
    if (user == null) return const SizedBox.shrink();

    final bool isOwnProfile = widget.externalUser == null;
    final bool isPremium = user.isPremium ?? subscriptionState.isPremium;
    final userName =
        user.name.isNotEmpty ? user.name : 'Kullanıcı';
    final careerStage =
        user.careerStage.isNotEmpty ? user.careerStage : 'Bilinmiyor';
    final location =
        user.location.isNotEmpty ? user.location : 'Konum yok';

    final commentCount = widget.externalUser == null
        ? placeState.myFeedbacks.length.toString()
        : (externalCommentCount?.toString() ?? '—');

    final followerCount =
        followState.followerCount.toString();
    final followingCount =
        followState.followingCount.toString();

    final avatarSize = 80.0;
    final profileImagePath = _effectiveProfileImagePath(user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ProfileAvatar(
                    imagePath: profileImagePath,
                    size: avatarSize,
                    onTap: !_isLoading
                        ? () {
                      if (widget.externalUser != null &&
                          profileImagePath != null) {
                        ImagePreviewViewer.show(
                          context,
                          [profileImagePath],
                        );
                      } else if (widget.avatarClickable) {
                        _openPhotoPickerSheet(context);
                      }
                    }
                        : null,
                  ),

                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    ),

                  if (widget.showEditButton)
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: EditProfileButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileEditScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      count: commentCount,
                      label: loc.comment,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyPlaceReviewsScreen(
                              externalUserId:
                                  widget.externalUser?.id,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildStat(
                      count: followerCount,
                      label: loc.followers,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyConnectionScreen(
                              initialTabIndex: 0,
                              externalUserId:
                                  widget.externalUser?.id,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildStat(
                      count: followingCount,
                      label: loc.following,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyConnectionScreen(
                              initialTabIndex: 1,
                              externalUserId:
                                  widget.externalUser?.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (widget.showLabels) ...[
            Row(
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralDark,
                  ),
                ),
                const SizedBox(width: 6),

                if (isPremium)
                  const Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: AppColors.primary,
                  )
                else if (isOwnProfile)
                  BecomePremiumBadge(
                    onSubscribed: () async {
                      await context
                          .read<SubscriptionStateNotifier>()
                          .fetchMySubscription();
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$careerStage · $location',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.neutralText,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat({
    required String count,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.neutralDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.neutralText,
            ),
          ),
        ],
      ),
    );
  }
}
