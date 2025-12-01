import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? label;
  final IconData? icon;
  final bool uppercase;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final Color? borderColor;
  final Color? iconColor;
  final Color? labelColor;
  final Color? textColor;
  final Color? hintTextColor;

  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  final bool isExpandable;

  final TextInputType? keyboardType; // 🔹 Klavye tipi eklendi
  final List<TextInputFormatter>? inputFormatters; // 🔹 Opsiyonel input formatlayıcı

  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.icon,
    this.uppercase = false,
    this.controller,
    this.focusNode,
    this.borderColor,
    this.iconColor,
    this.labelColor,
    this.textColor,
    this.hintTextColor,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.isExpandable = false,
    this.keyboardType, // 🔹 constructor'a eklendi
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final borderClr = widget.borderColor ?? AppColors.textFieldBorder;
    final iconClr = widget.iconColor ?? AppColors.textFieldText;
    final labelClr = widget.labelColor ?? AppColors.onboardingTitle;
    final textClr = widget.textColor ?? AppColors.textFieldText;
    final hintClr = widget.hintTextColor ?? AppColors.textFieldText.withOpacity(0.5);

    final field = TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      style: AppTextStyles.textFieldText.copyWith(color: textClr),
      keyboardType: widget.keyboardType ?? TextInputType.text, // 🔹 sadece sayı klavyesi vs
      inputFormatters: widget.inputFormatters, // 🔹 filtre desteği
      textCapitalization:
          widget.uppercase ? TextCapitalization.characters : TextCapitalization.none,
      onChanged: (value) {
        if (widget.uppercase) {
          final newText = value.toUpperCase();
          if (_controller.text != newText) {
            final pos = _controller.selection;
            _controller.value = TextEditingValue(
              text: newText,
              selection: pos,
            );
          }
        }
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      minLines: widget.isExpandable ? 1 : 1,
      maxLines: widget.isExpandable ? null : 1,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.textFieldText.copyWith(color: hintClr),
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: iconClr) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderClr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderClr, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderClr),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );

    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label!,
            style: AppTextStyles.textFieldText.copyWith(
              fontWeight: FontWeight.w600,
              color: labelClr,
            ),
          ),
          const SizedBox(height: 6),
          field,
        ],
      );
    }

    return field;
  }
}
