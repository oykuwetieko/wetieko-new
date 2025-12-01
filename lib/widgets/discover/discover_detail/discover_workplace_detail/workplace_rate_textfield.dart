import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkplaceRateTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const WorkplaceRateTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<WorkplaceRateTextField> createState() => _WorkplaceRateTextFieldState();
}

class _WorkplaceRateTextFieldState extends State<WorkplaceRateTextField> {
  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    final borderColor = isFocused
        ? AppColors.primary
        : AppColors.neutralGrey.withOpacity(0.3);
    final textColor = isFocused ? AppColors.primary : AppColors.neutralText;

    final local = AppLocalizations.of(context)!;

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
            local.writeComment,
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
                maxLength: 500,
                maxLines: null,
                onChanged: (text) {
  if (text.isNotEmpty) {
    final formatted =
        text[0].toUpperCase() + text.substring(1); 
    if (formatted != text) {
      widget.controller.value = widget.controller.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
  setState(() {});
},

                decoration: InputDecoration(
                  hintText: local.shareExperienceHint,
                  hintStyle: TextStyle(color: textColor),
                  counterText: "",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: textColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 14,
                child: Text(
                  "${widget.controller.text.length}/500",
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
