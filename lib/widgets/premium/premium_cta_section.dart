import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class PremiumCtaSection extends StatelessWidget {
  // 🔹 Tüm callback'leri nullable yaptık:
  final VoidCallback? onSubscribe;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;
  final VoidCallback? onRestore;

  const PremiumCtaSection({
    super.key,
    this.onSubscribe,
    this.onTerms,
    this.onPrivacy,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      children: [
        // 🔹 Abone Ol Butonu
        ElevatedButton(
          onPressed: onSubscribe, // artık null olabilir
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            shadowColor: AppColors.primary.withOpacity(0.4),
            elevation: 8,
          ),
          child: Text(
            locale.subscribeNow,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 🔹 Legal linkler
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legalLink(locale.termsOfUse, onTerms),
            _divider(),
            _legalLink(locale.privacyPolicy, onPrivacy),
            _divider(),
            _legalLink(locale.restorePurchase, onRestore),
          ],
        ),
      ],
    );
  }

  Widget _legalLink(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap, // artık null olabilir
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.privacyText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        "|",
        style: TextStyle(
          color: AppColors.privacyText,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
