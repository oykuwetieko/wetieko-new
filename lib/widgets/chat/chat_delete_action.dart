import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/data/repositories/message_repository.dart';
import 'package:Wetieko/data/sources/message_remote_data_source.dart';
import 'package:Wetieko/core/services/api_service.dart';

class ChatDeleteAction extends StatelessWidget {
  final String messageId;
  final VoidCallback onDeleted;

  const ChatDeleteAction({
    super.key,
    required this.messageId,
    required this.onDeleted,
  });

  Future<void> _deleteMessage(BuildContext context) async {
    try {
      final repo = MessageRepository(MessageRemoteDataSource(ApiService()));
      await repo.deleteMessage(messageId);

    
      onDeleted();

    } catch (e) {
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      onPressed: (_) => _deleteMessage(context), // direkt silme
      backgroundColor: AppColors.primary.withOpacity(0.15),
      padding: EdgeInsets.zero,
      child: const Center(
        child: Icon(
          Icons.delete_forever,
          size: 32,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
