import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class FeedbackTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const FeedbackTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<FeedbackTextField> createState() => _FeedbackTextFieldState();
}

class _FeedbackTextFieldState extends State<FeedbackTextField> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isFocused = widget.focusNode.hasFocus;
    final length = widget.controller.text.length;

    // İçteki textfield border rengi (sadece focus olduğunda mavi, aksi halde gri)
    final borderColor =
        isFocused ? AppColors.primary : AppColors.neutralGrey.withOpacity(0.3);

    final textColor = isFocused ? AppColors.primary : AppColors.neutralText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutralGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.feedbackWriteLabel, // ✅ "Geri Bildirim Yaz"
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDark,
            ),
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 300, // ✅ 300 karakter limiti
                maxLines: null,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: loc.shareExperienceHint, // ✅ "Deneyimini bizimle paylaş..."
                  hintStyle: TextStyle(color: textColor),
                  counterText: "",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor, width: 2),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 14,
                child: Text(
                  "$length/300",
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
