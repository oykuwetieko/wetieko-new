import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class PremiumIntroSection extends StatelessWidget {
  const PremiumIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Row(
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  locale.premiumTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _FeatureRow(
            icon: Icons.chat_bubble_outline,
            text: locale.featureChat,
          ),
          _FeatureRow(
            icon: Icons.remove_red_eye_outlined,
            text: locale.featureProfileViews,
          ),
          // 🔥 featureProfileAccess satırı kaldırıldı
          _FeatureRow(
            icon: Icons.location_on_outlined,
            text: locale.featureCheckin,
          ),
          _FeatureRow(
            icon: Icons.verified_rounded,
            text: locale.featureBadges,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _FeatureRow({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
