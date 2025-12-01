import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

enum SimpleNotificationType {
  profileView,
  newFollower,
  eventUpdated,
  eventDeleted,
  general,
}

class NotificationSummaryCard extends StatelessWidget {
  final SimpleNotificationType type;
  final String title;
  final String? subtitle;
  final String time;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const NotificationSummaryCard({
    super.key,
    required this.type,
    required this.title,
    this.subtitle,
    required this.time,
    this.imageUrl,
    this.onTap,
    this.onAccept,
    this.onDecline,
  });

  bool get _showAvatar =>
      !(type == SimpleNotificationType.eventUpdated ||
        type == SimpleNotificationType.eventDeleted);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final defaultSubtitle = _defaultSubtitleForType(type, l10n);

    return InkWell(
      onTap: type == SimpleNotificationType.newFollower ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.tagBackground, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_showAvatar) ...[
              _buildAvatar(),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.neutralText,
                        ),
                      ),
                    ],
                  ),
                  if ((subtitle ?? defaultSubtitle).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle ?? defaultSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.fabBackground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (type == SimpleNotificationType.newFollower) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _actionButton(
                          icon: Icons.check_rounded,
                          label: l10n.approve,
                          onPressed: onAccept,
                          iconColor: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        _actionButton(
                          icon: Icons.close_rounded,
                          label: l10n.delete,
                          onPressed: onDecline,
                          iconColor: AppColors.categoryInactiveText,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(imageUrl!),
          backgroundColor: AppColors.primary.withOpacity(0.1),
        );
      } else {
        return CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage(imageUrl!),
          backgroundColor: AppColors.primary.withOpacity(0.1),
        );
      }
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: const Icon(Icons.person, color: AppColors.primary, size: 24),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      splashColor: iconColor.withOpacity(0.08),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.categoryInactiveBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.neutralGrey.withOpacity(0.5),
            width: 0.9,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _defaultSubtitleForType(
      SimpleNotificationType type, AppLocalizations l10n) {
    switch (type) {
      case SimpleNotificationType.profileView:
        return l10n.viewedYourProfile;
      case SimpleNotificationType.newFollower:
        return l10n.startedFollowingYou;
      case SimpleNotificationType.eventUpdated:
        return l10n.notificationTitleEventUpdated;
      case SimpleNotificationType.eventDeleted:
        return l10n.notificationTitleEventDeleted;
      case SimpleNotificationType.general:
      default:
        return '';
    }
  }
}
