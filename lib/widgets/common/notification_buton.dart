import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/06_notification_screen/01_notification_screen.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AppNotificationStateNotifier>();
    final int unreadNotificationCount =
        notifier.unreadSummary['totalUnread'] ?? 0; // 🔹 okunmamış toplam sayısı
    final bool hasNotification = unreadNotificationCount > 0;

    return GestureDetector(
      onTap: () async {
        // 🔹 Bildirim ekranına gitmeden önce özet yenileniyor
        await notifier.fetchUnreadSummary();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationScreen(
              unreadNotificationCount: unreadNotificationCount,
            ),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tagBackground,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: AppColors.tagText,
              ),
            ),
          ),
          if (hasNotification)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
                child: Center(
                  child: Text(
                    unreadNotificationCount > 9
                        ? '9+'
                        : '$unreadNotificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
