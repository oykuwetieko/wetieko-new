import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/06_notification_screen/02_notification_detail_list_screen.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';

class NotificationTypeTag extends StatelessWidget {
  final String? type;

  const NotificationTypeTag({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = context.watch<AppNotificationStateNotifier>();

    // 👇 Backend'den gelen yapı:
    // { "totalUnread": 7, "byType": { ... } }
    final summary = notifier.unreadSummary;
    final byType = summary['byType'] ?? {};

    // 🔹 Gösterilecek tipler
    final List<String> shownTypes = [
      'profile_view',
      'follow_request',
      'follow_accepted',
      'event_updated',
      'event_deleted',
    ];

    return Column(
      children: List.generate(shownTypes.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.neutralGrey.withOpacity(0.4),
            ),
          );
        }

        final index = i ~/ 2;
        final typeKey = shownTypes[index];
        final count = byType[typeKey] ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
            onTap: () async {
              // 🔹 Önce bu tür bildirimleri okundu yap
              await context
                  .read<AppNotificationStateNotifier>()
                  .markTypeAsRead(typeKey);

              // 🔹 Detay ekranına git
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationDetailListScreen(type: typeKey),
                ),
              );

              // 🔥 GERİ DÖNÜNCE O ANKI GÜNCEL SUMMARY'YI ÇEK
              await context
                  .read<AppNotificationStateNotifier>()
                  .fetchUnreadSummary();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: _buildTile(_typeData(typeKey, l10n), count: count),
          ),
        );
      }),
    );
  }

  Widget _buildTile(_NotificationTypeData data, {int count = 0}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.closeButtonBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          data.icon,
          size: 20,
          color: AppColors.closeButtonIcon,
        ),
      ),
      title: Row(
        children: [
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDark,
            ),
          ),
          if (count > 0)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        data.subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.neutralText,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.categoryInactiveText,
      ),
    );
  }

  _NotificationTypeData _typeData(String type, AppLocalizations l10n) {
    switch (type) {
      case 'profile_view':
        return _NotificationTypeData(
          Icons.visibility_outlined,
          l10n.profileViewedTitle,
          l10n.profileViewedSubtitle,
        );
      case 'follow_request':
        return _NotificationTypeData(
          Icons.person_add_alt_outlined,
          l10n.newFollowerTitle,
          l10n.newFollowerSubtitle,
        );
      case 'follow_accepted':
        return _NotificationTypeData(
          Icons.handshake_outlined,
          l10n.followAcceptedTitle,
          l10n.followAcceptedSubtitle,
        );
      case 'event_updated':
        return _NotificationTypeData(
          Icons.edit_calendar_outlined,
          l10n.notificationTitleEventUpdated,
          l10n.notificationDescEventUpdated,
        );
      case 'event_deleted':
        return _NotificationTypeData(
          Icons.event_busy_outlined,
          l10n.notificationTitleEventDeleted,
          l10n.notificationDescEventDeleted,
        );
      default:
        return _NotificationTypeData(
          Icons.notifications_none_rounded,
          l10n.generalNotificationTitle,
          l10n.generalNotificationSubtitle,
        );
    }
  }
}

class _NotificationTypeData {
  final IconData icon;
  final String title;
  final String subtitle;
  _NotificationTypeData(this.icon, this.title, this.subtitle);
}
