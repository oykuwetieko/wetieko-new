import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/chat/chat_overview_list.dart';
import 'package:Wetieko/widgets/chat/recent_interactions_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/data/repositories/message_repository.dart';
import 'package:Wetieko/data/sources/message_remote_data_source.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/message_model.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/widgets/chat/discover_users_button.dart';
import 'package:Wetieko/core/services/message_socket_service.dart';
import 'package:Wetieko/states/subscription_state_notifier.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with RouteAware {
  late final MessageRepository _repo;
  final MessageSocketService _socketService = MessageSocketService();

  List<MessageModel> _conversations = [];
  bool _loading = true;
  String _searchQuery = '';
  String? _currentUserId;
  String? _accessToken;
  bool? _isPremium;

  StreamSubscription<MessageModel>? _subNew;
  StreamSubscription<MessageModel>? _subSent;
  StreamSubscription<List<MessageModel>>? _subConvos;

  @override
  void initState() {
    super.initState();
    _repo = MessageRepository(MessageRemoteDataSource(ApiService()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPremiumStatus();

      final userState = context.read<UserStateNotifier>().state;
      final user = userState.user;
      final token = user?.accessToken; // 🔥 TOKEN BURADA

      if (user != null && token != null) {
        _currentUserId = user.id;
        _accessToken = token;

        _connectAndSubscribe();
        await _loadConversations();
      }
    });
  }

  Future<void> _checkPremiumStatus() async {
    final subState = context.read<SubscriptionStateNotifier>();
    await subState.fetchMySubscription();
    if (!mounted) return;
    setState(() => _isPremium = subState.isPremium);
  }

  void _connectAndSubscribe() {
    if (_currentUserId == null || _accessToken == null) return;

    // 🔥 3 parametre: baseUrl, userId, token
   _socketService.connect(ApiService.baseUrl, _currentUserId!);


    _subNew?.cancel();
    _subSent?.cancel();
    _subConvos?.cancel();

    _subNew = _socketService.newMessageStream.listen((msg) {
      print("📨 Yeni mesaj: ${msg.id}");
    });

    _subSent = _socketService.messageSentStream.listen((msg) {
      print("📤 Mesaj gönderildi: ${msg.id}");
    });

    _subConvos = _socketService.conversationListUpdatedStream.listen((convos) {
      if (!mounted) return;
      print("🔄 Conversation list updated (${convos.length})");
      setState(() => _conversations = convos);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _socketService.enableConversationListListening(true);
  }

  @override
  void didPushNext() {
    _socketService.enableConversationListListening(false);
    _subConvos?.cancel();
  }

  @override
  void didPopNext() {
    _socketService.enableConversationListListening(true);
    _connectAndSubscribe();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _socketService.enableConversationListListening(false);
    _subNew?.cancel();
    _subSent?.cancel();
    _subConvos?.cancel();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    try {
      final convos = await _repo.getConversationList();
      if (!mounted) return;
      setState(() {
        _conversations = convos;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_isPremium == null || _currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Map<String, User> uniqById = {};
    for (final msg in _conversations) {
      final other = msg.senderId == _currentUserId ? msg.receiver : msg.sender;
      if (other.id.isNotEmpty) {
        uniqById[other.id] = other;
      }
    }
    final recentUsers = uniqById.values.toList();

    final filteredConversations = _conversations.where((msg) {
      final other = msg.senderId == _currentUserId ? msg.receiver : msg.sender;
      return other.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: loc.messages,
          showStepBar: false,
          actionWidget: const DiscoverUsersButton(),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _conversations.isEmpty
                ? const EmptyStateWidget(type: EmptyStateType.noMessages)
                : Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            hintText: loc.searchUsers,
                            hintStyle: TextStyle(
                              color: AppColors.textFieldText.withOpacity(0.5),
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textFieldBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecentInteractionsRow(users: recentUsers),
                      Expanded(
                        child: ChatOverviewList(
                          conversations: filteredConversations,
                          onConversationDeleted: _loadConversations,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
