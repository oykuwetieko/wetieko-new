import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/chat/chat_app_bar.dart';
import 'package:Wetieko/widgets/chat/chat_bubble.dart';
import 'package:Wetieko/widgets/chat/message_input.dart';
import 'package:Wetieko/widgets/chat/message_info_card.dart';
import 'package:Wetieko/widgets/chat/message_request_card.dart';
import 'package:Wetieko/widgets/chat/message_restriction_card.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/models/message_model.dart';
import 'package:Wetieko/data/repositories/message_repository.dart';
import 'package:Wetieko/data/repositories/message_access_repository.dart';
import 'package:Wetieko/data/repositories/restriction_repository.dart';
import 'package:Wetieko/data/sources/message_remote_data_source.dart';
import 'package:Wetieko/data/sources/message_access_remote_data_source.dart';
import 'package:Wetieko/data/sources/restriction_remote_data_source.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/core/services/message_socket_service.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatDetailScreen extends StatefulWidget {
  final User externalUser;
  const ChatDetailScreen({super.key, required this.externalUser});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final MessageRepository _messageRepo;
  late final MessageAccessRepository _accessRepo;
  late final RestrictionRepository _restrictionRepo;
  final MessageSocketService _socketService = MessageSocketService();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = [];
  bool _loading = true;
  bool? _hasAccess;
  bool _isRestricted = false;
  String? _pendingRequestId;
  late final String _currentUserId;
  late final String _accessToken;

  StreamSubscription<MessageModel>? _subNew;
  StreamSubscription<MessageModel>? _subSent;
  StreamSubscription<Map<String, dynamic>>? _subAccessAccepted;
  StreamSubscription<Map<String, dynamic>>? _subRestricted;
  StreamSubscription<Map<String, dynamic>>? _subUnrestricted;
  StreamSubscription<String>? _subDeleted;

@override
void initState() {
  super.initState();

  final user = context.read<UserStateNotifier>().state.user!;
  _currentUserId = user.id;
  _accessToken = user.accessToken ?? "";   // ✅ NULL-SAFE, HATA YOK

  final api = ApiService();
  _messageRepo = MessageRepository(MessageRemoteDataSource(api));
  _accessRepo = MessageAccessRepository(MessageAccessRemoteDataSource(api));
  _restrictionRepo = RestrictionRepository(RestrictionRemoteDataSource(api));

  _loadConversation();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_accessToken.isNotEmpty) {
      // 🔥 3 parametreli yeni socket bağlantısı
   _socketService.connect(ApiService.baseUrl, _currentUserId);
    } else {
      debugPrint("⚠️ accessToken boş → socket bağlanmadı");
    }

    _subscribeStreams();
  });
}


  Future<void> _markMessagesAsRead() async {
    try {
      if (_messages.isEmpty) return;
      final unreadExist = _messages.any(
        (m) => m.receiverId == _currentUserId && !m.isRead,
      );
      if (unreadExist) {
        debugPrint("👁️ Okunmamış mesajlar var → read gönderiliyor...");
        _socketService.markAsRead(_currentUserId, widget.externalUser.id);
      }
    } catch (e) {
      debugPrint("⚠️ Okunma işaretleme hatası: $e");
    }
  }

  void _subscribeStreams() {
    _subNew?.cancel();
    _subSent?.cancel();
    _subAccessAccepted?.cancel();
    _subRestricted?.cancel();
    _subUnrestricted?.cancel();
    _subDeleted?.cancel();

    // 🔹 Yeni mesaj event
    _subNew = _socketService.newMessageStream.listen((msg) async {
      if (!mounted) return;

      final isThisChat = msg.senderId == widget.externalUser.id ||
                         msg.receiverId == widget.externalUser.id;

      if (isThisChat) {
        setState(() => _messages.add(msg));
        _scrollToBottom();

        if (msg.receiverId == _currentUserId) {
          await _markMessagesAsRead();
        }
      }
    });

    // 🔹 Mesaj gönderildi
    _subSent = _socketService.messageSentStream.listen((msg) {
      if (!mounted) return;

      final isMine = msg.senderId == _currentUserId;
      final isSameChat = msg.receiverId == widget.externalUser.id;

      if (isMine && isSameChat) {
        final exists = _messages.any((m) => m.id == msg.id);
        if (!exists) {
          setState(() => _messages.add(msg));
          _scrollToBottom();
        }
      }
    });

    // 🔹 Access accepted
    _subAccessAccepted = _socketService.accessAcceptedStream.listen((data) {
      if (!mounted) return;

      final requesterId = data['requesterId'];
      final receiverId = data['receiverId'];

      final isSameChat =
          (requesterId == _currentUserId && receiverId == widget.externalUser.id) ||
          (receiverId == _currentUserId && requesterId == widget.externalUser.id);

      if (isSameChat) {
        setState(() {
          _hasAccess = true;
          _pendingRequestId = null;
          if (_messages.isNotEmpty && _messages.last.pending == true) {
            _messages[_messages.length - 1] =
                _messages.last.copyWith(pending: false);
          }
        });
      }
    });

    // 🔹 Restrict events
    _subRestricted = _socketService.restrictedStream.listen((data) {
      if (!mounted) return;
      if (data['blockedId'] == widget.externalUser.id &&
          data['blockerId'] == _currentUserId) {
        setState(() => _isRestricted = true);
      }
    });

    _subUnrestricted = _socketService.unrestrictedStream.listen((data) {
      if (!mounted) return;
      if (data['blockedId'] == widget.externalUser.id &&
          data['blockerId'] == _currentUserId) {
        setState(() => _isRestricted = false);
      }
    });

    // 🔹 Mesaj silindi
    _subDeleted = _socketService.messageDeletedStream.listen((msgId) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationWrapper(initialIndex: 1),
        ),
        (route) => false,
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadConversation() async {
    try {
      final restrictedUsers = await _restrictionRepo.getRestrictedUsers();
      final isRestrictedUser =
          restrictedUsers.any((u) => u['blocked']['id'] == widget.externalUser.id);

      final msgs =
          await _messageRepo.getConversation(widget.externalUser.id);

      msgs.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final lastMsg = msgs.isNotEmpty ? msgs.last : null;
      final bool pending = lastMsg?.pending == true;

      setState(() {
        _messages = msgs;
        _isRestricted = isRestrictedUser;
        _hasAccess = pending ? false : true;
        _loading = false;
      });

      if (!_isRestricted) {
        await _loadRequestIfExists();
        await _markMessagesAsRead();
      }

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

Future<void> _loadRequestIfExists() async {
  try {
    final incoming = await _accessRepo.getIncomingRequests();

    print("📥 INCOMING REQUESTS → $incoming");

    if (incoming.isEmpty) {
      print("⚠️ Incoming boş → request yok");
      return;
    }

    Map<String, dynamic>? match;

    for (var r in incoming) {
      print(
        "🔎 CHECK → requesterId: ${r['requesterId']} | "
        "receiverId: ${r['receiverId']} | "
        "externalUser.id: ${widget.externalUser.id} | "
        "currentUserId: $_currentUserId"
      );

      final requesterId = r['requesterId'].toString();
      final receiverId = r['receiverId'].toString();
      final externalId = widget.externalUser.id.toString();
      final currentId = _currentUserId.toString();

      if (requesterId == externalId && receiverId == currentId) {
        match = r;
        break;
      }
    }

    print("🔍 MATCH RESULT → $match");

    if (match != null) {
      final id = match['id'].toString();
      print("🆔 Request ID bulundu → $id");

      setState(() {
        _pendingRequestId = id;
        _hasAccess = false;
      });
    } else {
      print("⚠️ Bu kullanıcıdan gelen pending request yok.");
    }
  } catch (e) {
    print("❗ HATA: _loadRequestIfExists → $e");
  }
}






 void _sendMessage(String text) {
  if (_hasAccess != true || _isRestricted) return;

  print("📨 ChatDetail → sendMessage çalıştı");
  print("➡ senderId: $_currentUserId");
  print("➡ receiverId: ${widget.externalUser.id}");
  print("➡ content: $text");

  _socketService.sendMessage(
    _currentUserId.toString(),
    widget.externalUser.id.toString(),
    text,
  );
}


  Future<void> _acceptRequest(String requestId) async {
    try {
      await _accessRepo.acceptRequest(requestId);
      await _loadConversation();
      setState(() {
        _hasAccess = true;
        _pendingRequestId = null;
      });
    } catch (_) {}
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      await _messageRepo.deleteMessage(messageId);
      if (!mounted) return;

      setState(() {
        _messages.removeWhere((m) => m.id == messageId);
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationWrapper(initialIndex: 1),
        ),
        (route) => false,
      );
    } catch (_) {}
  }

  Future<void> _restrictUser() async {
    try {
      await _restrictionRepo.restrictUser(widget.externalUser.id);
      setState(() => _isRestricted = true);
    } catch (_) {}
  }

  Future<void> _unrestrictUser() async {
    try {
      await _restrictionRepo.unrestrictUser(widget.externalUser.id);
      setState(() => _isRestricted = false);
    } catch (_) {}
  }

  @override
  void dispose() {
    _subNew?.cancel();
    _subSent?.cancel();
    _subAccessAccepted?.cancel();
    _subRestricted?.cancel();
    _subUnrestricted?.cancel();
    _subDeleted?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.externalUser;
    final loc = AppLocalizations.of(context)!;

    if (_loading || _hasAccess == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lastMsg = _messages.isNotEmpty ? _messages.last : null;
    final bool isPending =
        lastMsg?.pending == true || lastMsg?.pending == "true";

    final bool isMeSender = lastMsg?.senderId == _currentUserId;

    Widget bottomWidget;

    if (_isRestricted) {
      bottomWidget = MessageRestrictionCard(
        userName: user.name,
        onDelete: () {
        if (_messages.isNotEmpty) _deleteMessage(_messages.last.id.toString());

        },
        onUnrestrict: _unrestrictUser,
      );
    } else if (_messages.isEmpty) {
      bottomWidget = MessageInput(onSend: _sendMessage);
    } else if (isPending || _hasAccess == false) {
      bottomWidget = isMeSender
          ? const MessageInfoCard()
          : MessageRequestCard(
              senderName: user.name,
              requestId: _pendingRequestId,
              onAccept: _acceptRequest,
              onDecline: _restrictUser,
            );
    } else {
      bottomWidget = MessageInput(onSend: _sendMessage);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: ChatAppBar(
          user: user,
          onBack: () => Navigator.pop(context),
          onDelete: () {
            if (_messages.isEmpty) return;

          final lastMessageId = _messages.last.id.toString();


            CustomAlert.show(
              context,
              title: loc.deleteMessageConfirmationTitle,
              description: loc.deleteMessageWarning,
              icon: Icons.delete_forever,
              confirmText: loc.deletePhoto,
              onConfirm: () => _deleteMessage(lastMessageId),
              cancelText: loc.cancel,
              onCancel: () {},
              isDestructive: true,
            );
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (ctx, i) {
                        final msg = _messages[_messages.length - 1 - i];
                        final bool isMe = msg.senderId == _currentUserId;

                        final String? avatar = !isMe
                            ? (msg.sender.profileImage ?? user.profileImage)
                            : null;

                        return ChatBubble(
                          text: msg.content,
                          isMe: isMe,
                          time:
                              "${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                          avatar: avatar,
                        );
                      },
                    ),
            ),
            bottomWidget,
          ],
        ),
      ),
    );
  }
}
