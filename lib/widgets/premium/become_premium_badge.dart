import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/08_premium_screen/01_premium_offer_screen.dart';

class BecomePremiumBadge extends StatelessWidget {
  final bool compact;
  final VoidCallback? onSubscribed;

  const BecomePremiumBadge({
    super.key,
    this.compact = false,
    this.onSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    final double height = compact ? 22 : 24;
    final double iconSize = compact ? 13 : 14.5;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PremiumOfferScreen()),
        );
        if (result == true && onSubscribed != null) {
          onSubscribed!();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 2 : 3,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 👑 Premium Rozeti
            Icon(
              Icons.workspace_premium_rounded,
              size: iconSize + 0.5,
              color: AppColors.primary,
            ),

            // 🔹 Aradaki küçük nokta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.5),
              child: Container(
                width: 3.5,
                height: 3.5,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ✅ Verified Rozeti
            Icon(
              Icons.verified_rounded,
              size: iconSize,
              color: AppColors.primary.withOpacity(0.9),
            ),
          ],
        ),
      ),
    );
  }
}
