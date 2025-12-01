import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class MessageInfoCard extends StatelessWidget {
  const MessageInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // ✅ localization erişimi

    return Container(
      width: double.infinity,
      color: AppColors.fabBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Başlık
          Text(
            loc.messageRequestSent, // ✅ l10n
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),

          // 🔹 Açıklama
          Text(
            loc.messageRequestInfo, // ✅ l10n
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.85),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),
          Divider(
            height: 26,
            thickness: 0.6,
            color: Colors.white.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
