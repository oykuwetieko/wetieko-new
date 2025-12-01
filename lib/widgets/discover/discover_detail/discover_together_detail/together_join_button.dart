import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class TogetherJoinButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? buttonText;
  final bool isDisabled;

  const TogetherJoinButton({
    super.key,
    required this.onTap,
    this.buttonText,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final displayText = buttonText ?? loc.createCollaborate;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.logoutButtonBackground // 🔴 devre dışı rengi
              : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDisabled ? Icons.event_busy : Icons.people_alt,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              displayText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
