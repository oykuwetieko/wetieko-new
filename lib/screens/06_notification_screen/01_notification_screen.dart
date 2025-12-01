import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/notifications/notification_type_tag.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';

class NotificationScreen extends StatefulWidget {
  /// 🔹 Bildirim sayısı artık opsiyonel parametre
  final int unreadNotificationCount;
  const NotificationScreen({super.key, this.unreadNotificationCount = 0});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // 🆕 Sayfa açıldığında okunmamış bildirim özeti çek
    Future.microtask(() =>
        context.read<AppNotificationStateNotifier>().fetchUnreadSummary());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final notifier = context.watch<AppNotificationStateNotifier>();

    // 🧮 Dinamik toplam okunmamış sayısı
    final totalUnread = notifier.unreadSummary['totalUnread'] ??
        widget.unreadNotificationCount;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: totalUnread > 0
            ? '${loc.notifications} ($totalUnread)'
            : loc.notifications,
        showStepBar: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: NotificationTypeTag(),
        ),
      ),
    );
  }
}
