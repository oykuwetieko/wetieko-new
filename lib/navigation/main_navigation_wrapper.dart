import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/screens/03_discover_screen/01_main_discover_screen.dart';
import 'package:Wetieko/screens/07_chat_screen/01_chat_list_screen.dart';
import 'package:Wetieko/screens/04_create_options_screen/01_main_create_options_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/04_event_memories_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/01_main_profile_settings_screen.dart';
import 'package:Wetieko/widgets/common/custom_bottom_nav_bar.dart';
import 'package:Wetieko/states/subscription_state_notifier.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/services/api_service.dart';

class MainNavigationWrapper extends StatefulWidget {
  static int currentIndex = 0;

  final int initialIndex;
  final String? initialDiscoverCategoryKey;

  const MainNavigationWrapper({
    Key? key,
    this.initialIndex = 0,
    this.initialDiscoverCategoryKey,
  }) : super(key: key);

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    MainNavigationWrapper.currentIndex = _currentIndex;

    _screens = [
      DiscoverScreen(initialCategoryKey: widget.initialDiscoverCategoryKey),
      const ChatListScreen(),
      const MainCreateOptionsScreen(),
      const EventMemoriesScreen(),
      const MainProfileSettingsScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPremiumStatus();

      final userState = context.read<UserStateNotifier>().state;
      final user = userState.user;

      if (user != null) {
        final appNotifier = context.read<AppNotificationStateNotifier>();

        // 🔥 SOCKET BAĞLANTISI
        appNotifier.connectSockets(ApiService.baseUrl, user.id);

        // 🔥 İlk yükleme
        await appNotifier.fetchUnreadSummary();
        await appNotifier.initUnreadMessageCount();
        await appNotifier.fetchNotifications();
      }
    });
  }

  @override
  void dispose() {
    context.read<AppNotificationStateNotifier>().disconnectSockets();
    super.dispose();
  }

  Future<void> _checkPremiumStatus() async {
    final subscriptionState =
        Provider.of<SubscriptionStateNotifier>(context, listen: false);
    try {
      await subscriptionState.fetchMySubscription();
    } catch (_) {}
  }

  void _onTap(int index) {
    if (!mounted) return;

    setState(() {
      _currentIndex = index;
      MainNavigationWrapper.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadMsgCount =
        context.watch<AppNotificationStateNotifier>().unreadMessageCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        unreadCount: unreadMsgCount,
      ),
    );
  }
}
