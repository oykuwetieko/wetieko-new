// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/extensions/time_ago_extension.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/notifications/notification_summary_card.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/widgets/premium/premium_promo_widget.dart';
import 'package:Wetieko/states/follow_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/profile_view_state_notifier.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';
import 'package:Wetieko/models/notification_model.dart';
import 'package:Wetieko/models/app_notification.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/screens/03_discover_screen/04_discover_activity_detail_screen.dart';
import 'package:Wetieko/screens/03_discover_screen/02_discover_together_detail_screen.dart';

class NotificationDetailListScreen extends StatefulWidget {
  final String? type;
  const NotificationDetailListScreen({super.key, this.type});

  @override
  State<NotificationDetailListScreen> createState() =>
      _NotificationDetailListScreenState();
}

class _NotificationDetailListScreenState
    extends State<NotificationDetailListScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.type == 'follow_request' || widget.type == 'new_follower') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FollowStateNotifier>().fetchPendingRequests();
      });
    } else if (widget.type == 'follow_accepted') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FollowStateNotifier>().fetchAcceptedRequests();
      });
    } else if (widget.type == 'profile_view') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userId = context.read<UserStateNotifier>().user?.id;
        if (userId != null) {
          context.read<ProfileViewStateNotifier>().fetchProfileViews(userId);
        }
      });
    } else if (widget.type == 'event_updated' ||
        widget.type == 'event_deleted') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppNotificationStateNotifier>().fetchNotifications();
      });
    }
  }

  String _localizedEventType(String eventType, AppLocalizations l10n, Locale locale) {
    final lang = locale.languageCode;
    switch (eventType.toUpperCase()) {
      case 'BIRLIKTE_CALIS':
        return lang == 'tr' ? 'BİRLİKTE ÇALIŞ' : 'TOGETHER WORK';
      case 'ETKINLIK':
        return lang == 'tr' ? 'ETKİNLİK' : 'ACTIVITY';
      case 'COWORK':
        return 'COWORK';
      default:
        return eventType.toUpperCase();
    }
  }

  List<AppNotification> _getLatestNotificationsByEvent(
      List<AppNotification> notifications) {
    final Map<String, AppNotification> latestByEvent = {};

    for (final n in notifications) {
      final eventId = n.data?['eventId'];
      if (eventId == null) continue;
      final existing = latestByEvent[eventId];
      if (existing == null || n.createdAt.isAfter(existing.createdAt)) {
        latestByEvent[eventId] = n;
      }
    }

    return latestByEvent.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final follow = context.watch<FollowStateNotifier>();
    final profileViewState = context.watch<ProfileViewStateNotifier>();
    final userState = context.watch<UserStateNotifier>();
    final appNotif = context.watch<AppNotificationStateNotifier>();
    final isPremium = userState.user?.isPremium ?? false;

    // PREMIUM
    if (widget.type == 'profile_view' && !isPremium) {
      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: l10n.profileViews,
          showStepBar: false,
        ),
        body: PremiumPromoWidget(
          startAfterAppBar: false,
          onUpgraded: () => setState(() {}),
        ),
      );
    }

    // FOLLOW REQUESTS
    if (widget.type == 'follow_request' || widget.type == 'new_follower') {
      if (follow.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (follow.error != null) {
        return Scaffold(
          appBar: CustomAppBar(title: l10n.newFollowers, showStepBar: false),
          body: Center(child: Text(follow.error!)),
        );
      }

      if (follow.pendingRequests.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.onboardingBackground,
          appBar: CustomAppBar(title: l10n.newFollowers, showStepBar: false),
          body: const EmptyStateWidget(type: EmptyStateType.newFollow),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(title: l10n.newFollowers, showStepBar: false),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: follow.pendingRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final req = follow.pendingRequests[index];
            return NotificationSummaryCard(
              type: SimpleNotificationType.newFollower,
              title: req.follower.name,
              time: req.createdAt?.timeAgo() ?? '',
              imageUrl: req.follower.profileImage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfileViewScreen(externalUser: req.follower),
                  ),
                );
              },
              onAccept: () async {
                await context
                    .read<FollowStateNotifier>()
                    .updateFollowRequestStatus(req.id, "accepted");
              },
              onDecline: () async {
                await context
                    .read<FollowStateNotifier>()
                    .updateFollowRequestStatus(req.id, "rejected");
              },
            );
          },
        ),
      );
    }

    // FOLLOW ACCEPTED
    if (widget.type == 'follow_accepted') {
      if (follow.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (follow.error != null) {
        return Scaffold(
          appBar: CustomAppBar(title: l10n.followAcceptedListTitle, showStepBar: false),
          body: Center(child: Text(follow.error!)),
        );
      }

      if (follow.acceptedRequests.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.onboardingBackground,
          appBar: CustomAppBar(
            title: l10n.followAcceptedListTitle,
            showStepBar: false,
          ),
          body: const EmptyStateWidget(type: EmptyStateType.noFollowing),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(title: l10n.followAcceptedListTitle, showStepBar: false),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: follow.acceptedRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final req = follow.acceptedRequests[index];
            return NotificationSummaryCard(
              type: SimpleNotificationType.general,
              title: req.following?.name ?? "",
              subtitle: l10n.followAcceptedTitle,
              time: req.createdAt?.timeAgo() ?? '',
              imageUrl: req.following?.profileImage,
              onTap: () {
                if (req.following != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileViewScreen(externalUser: req.following!),
                    ),
                  );
                }
              },
            );
          },
        ),
      );
    }

    // PROFILE VIEWS
    if (widget.type == 'profile_view') {
      final grouped = profileViewState.groupedViews.values.toList();

      if (grouped.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.onboardingBackground,
          appBar: CustomAppBar(title: l10n.profileViews, showStepBar: false),
          body: const EmptyStateWidget(type: EmptyStateType.profileView),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(title: l10n.profileViews, showStepBar: false),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: grouped.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final summary = grouped[index];
            return NotificationSummaryCard(
              type: SimpleNotificationType.profileView,
              title: summary.viewer.name ?? "",
              time: summary.lastViewedAt.timeAgo(),
              imageUrl: summary.viewer.profileImage,
            );
          },
        ),
      );
    }

    // EVENT UPDATED
    if (widget.type == 'event_updated') {
      final eventUpdated = _getLatestNotificationsByEvent(
        appNotif.notifications
            .where((n) => n.type == 'event_updated')
            .cast<AppNotification>()
            .toList(),
      );

      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: l10n.notificationTitleEventUpdated,
          showStepBar: false,
        ),
        body: eventUpdated.isEmpty
            ? const EmptyStateWidget(type: EmptyStateType.noData)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: eventUpdated.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final n = eventUpdated[index];
                  final eventId = n.data?['eventId'];
                  final rawType = (n.data?['eventType'] ?? '').toString();
                  final eventType = _localizedEventType(
                    rawType,
                    l10n,
                    Localizations.localeOf(context),
                  );
                  final eventTitle = n.data?['eventTitle'] ?? 'Etkinlik';

                  return NotificationSummaryCard(
                    type: SimpleNotificationType.eventUpdated,
                    title: '$eventType ${l10n.eventUpdatedSuffix}',
                    subtitle: '$eventTitle ${l10n.eventUpdatedSubtitleSuffix}',
                    time: n.createdAt?.timeAgo() ?? '',
                    onTap: () async {
                      if (eventId == null) return;

                      final event = await context
                          .read<EventStateNotifier>()
                          .fetchEventDetail(eventId);

                      if (event == null) return;

                      if (event.type == 'BIRLIKTE_CALIS') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiscoverTogetherDetailScreen(event: event),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiscoverActivityDetailScreen(event: event),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      );
    }

    // EVENT DELETED
    if (widget.type == 'event_deleted') {
      final eventDeleted = appNotif.notifications
          .where((n) => n.type == 'event_deleted')
          .toList();

      return Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: l10n.notificationTitleEventDeleted,
          showStepBar: false,
        ),
        body: eventDeleted.isEmpty
            ? const EmptyStateWidget(type: EmptyStateType.noData)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: eventDeleted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final n = eventDeleted[index];
                  final rawType = (n.data?['eventType'] ?? '').toString();
                  final eventType = _localizedEventType(
                    rawType,
                    l10n,
                    Localizations.localeOf(context),
                  );
                  final eventTitle = n.data?['eventTitle'] ?? 'Etkinlik';

                  return NotificationSummaryCard(
                    type: SimpleNotificationType.eventDeleted,
                    title: '$eventType ${l10n.eventDeletedSuffix}',
                    subtitle: '$eventTitle ${l10n.eventDeletedSubtitleSuffix}',
                    time: n.createdAt?.timeAgo() ?? '',
                  );
                },
              ),
      );
    }

    // DEFAULT
    final items = widget.type == null
        ? _mockAllItems()
        : _mockItemsByType(widget.type!);

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: widget.type == null
            ? l10n.notifications
            : _titleFromType(l10n, widget.type!),
        showStepBar: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = items[index];
          return NotificationSummaryCard(
            type: _mapToSimpleType(item.type),
            title: item.name ?? item.title ?? '',
            time: item.time,
            imageUrl: item.imageUrl,
          );
        },
      ),
    );
  }

  List<NotificationModel> _mockAllItems() {
    return [
      NotificationModel(
          type: NotificationType.profileView, name: 'Merve', time: '4h'),
      NotificationModel(
          type: NotificationType.newFollower, name: 'Kerem', time: '1h'),
    ];
  }

  List<NotificationModel> _mockItemsByType(String type) {
    return _mockAllItems()
        .where((item) => _typeToString(item.type) == type)
        .toList();
  }

  String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.profileView:
        return 'profile_view';
      case NotificationType.newFollower:
        return 'follow_request';
      default:
        return '';
    }
  }

  SimpleNotificationType _mapToSimpleType(NotificationType type) {
    switch (type) {
      case NotificationType.profileView:
        return SimpleNotificationType.profileView;
      case NotificationType.newFollower:
        return SimpleNotificationType.newFollower;
      default:
        return SimpleNotificationType.general;
    }
  }

  String _titleFromType(AppLocalizations l10n, String type) {
    switch (type) {
      case 'profile_view':
        return l10n.profileViews;
      case 'follow_request':
        return l10n.newFollowers;
      case 'follow_accepted':
        return l10n.followAcceptedTitle;
      case 'event_updated':
        return l10n.notificationTitleEventUpdated;
      case 'event_deleted':
        return l10n.notificationTitleEventDeleted;
      default:
        return l10n.notifications;
    }
  }
}
