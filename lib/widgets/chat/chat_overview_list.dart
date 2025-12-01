import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/07_chat_screen/02_chat_detail_screen.dart';
import 'package:Wetieko/models/message_model.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/core/extensions/format_date_label_extension.dart';
import 'package:Wetieko/widgets/chat/chat_delete_action.dart';

class ChatOverviewList extends StatelessWidget {
  final List<MessageModel> conversations;
  final VoidCallback onConversationDeleted;

  const ChatOverviewList({
    super.key,
    required this.conversations,
    required this.onConversationDeleted,
  });

  Widget _buildChatTile(BuildContext context, MessageModel msg) {
    // 🔥 String'e çevrildi
    final currentUserId =
        context.read<UserStateNotifier>().state.user!.id.toString();

    // 🔥 int → String karşılaştırma
    final User otherUser =
        msg.senderId.toString() == currentUserId ? msg.receiver : msg.sender;

    // 🔥 int → String karşılaştırma
    final bool isIncoming = msg.receiverId.toString() == currentUserId;

    final bool showUnreadDot = isIncoming && !msg.isRead;

    final tile = InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(externalUser: otherUser),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.tagBackground,
                      foregroundImage: (otherUser.profileImage != null &&
                              otherUser.profileImage!.startsWith("http"))
                          ? NetworkImage(otherUser.profileImage!)
                          : (otherUser.profileImage != null &&
                                  otherUser.profileImage!.isNotEmpty)
                              ? AssetImage(otherUser.profileImage!)
                                  as ImageProvider
                              : null,
                      child: const Icon(Icons.person,
                          size: 24, color: Colors.white),
                    ),

                    if (showUnreadDot)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            otherUser.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              msg.createdAt.formatDateLabel(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              msg.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: showUnreadDot
                                    ? AppColors.primary
                                    : AppColors.neutralDark,
                                fontWeight: showUnreadDot
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              DateFormat('HH:mm').format(msg.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.neutralGrey.withOpacity(0.4),
            thickness: 1,
            indent: 70,
            endIndent: 0,
            height: 0,
          ),
        ],
      ),
    );

return Slidable(
  key: ValueKey(msg.id.toString()),   // ✅ BURASI DÜZELDİ
  endActionPane: ActionPane(
    motion: const DrawerMotion(),
    extentRatio: 0.25,
    children: [
    ChatDeleteAction(
  messageId: msg.id.toString(),   //  ✅ ZORUNLU DÜZELTME
  onDeleted: onConversationDeleted,
),

    ],
  ),
  child: tile,
);

  }

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const Center(child: Text("Henüz mesaj yok."));
    }

    return Container(
      color: AppColors.onboardingBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (ctx, i) {
          final msg = conversations[i];
          return _buildChatTile(ctx, msg);
        },
      ),
    );
  }
}
