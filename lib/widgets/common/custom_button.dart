import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool hasBorder;
  final IconData? icon;
  final String? iconAssetPath;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.hasBorder = false,
    this.icon,
    this.iconAssetPath,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: textColor ?? Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final Widget? leadingIcon = iconAssetPath != null
        ? Image.asset(
            iconAssetPath!,
            height: iconSize ?? 24,
            width: iconSize ?? 24,
          )
        : icon != null
            ? Icon(icon, size: iconSize ?? 24, color: textColor)
            : null;

    final buttonChild = leadingIcon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon,
              const SizedBox(width: 8),
              Text(text, style: textStyle),
            ],
          )
        : Text(text, style: textStyle);

    final noSplash = const MaterialStatePropertyAll(Colors.transparent);

    final buttonStyle = hasBorder
        ? OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: borderColor ?? backgroundColor ?? Colors.black,
            ),
          ).copyWith(
            overlayColor: noSplash,
            splashFactory: NoSplash.splashFactory,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.transparent,
          ).copyWith(
            overlayColor: noSplash,
            splashFactory: NoSplash.splashFactory,
          );

    return hasBorder
        ? OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
  }
}
