import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // ✅ Klavye kontrolü için eklendi

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      // ❌ Artık klavyeyi kapatmıyoruz, sadece input'u temizliyoruz
      // böylece mesaj atınca klavye kapanıp tekrar açılmıyor.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // ✅ Bellek sızıntısını önlemek için
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.onboardingBackground,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.neutralGrey),
                ),
                child: TextField(
                  focusNode: _focusNode, // ✅ Focus kontrolü burada
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.messageInputPlaceholder,
                    hintStyle:
                        const TextStyle(color: AppColors.neutralText),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _handleSend,
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
