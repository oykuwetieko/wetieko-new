import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/08_premium_screen/01_premium_offer_screen.dart';

class PremiumPromoWidget extends StatelessWidget {
  final VoidCallback? onUpgrade;
  final VoidCallback? onUpgraded; // 🔹 Premium alımı sonrası çağrılır
  final int featureIndex;
  final bool startAfterAppBar;

  const PremiumPromoWidget({
    super.key,
    this.onUpgrade,
    this.onUpgraded,
    this.featureIndex = 1,
    this.startAfterAppBar = false,
  });

  Future<void> _openPremiumScreen(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const PremiumOfferScreen()),
    );
    // 🔹 Geri dönülünce premium kontrolü yapılır
    if (onUpgraded != null) onUpgraded!();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    String title;
    String subtitle;
    switch (featureIndex) {
      case 2:
        title = loc.premiumTitle2;
        subtitle = loc.premiumSubtitle2;
        break;
      case 3:
        title = loc.premiumTitle3;
        subtitle = loc.premiumSubtitle3;
        break;
      default:
        title = loc.premiumTitle1;
        subtitle = loc.premiumSubtitle1;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🔹 Arka plan blur + karanlık cam efekti
        Positioned.fill(
          top: startAfterAppBar ? kToolbarHeight : 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
        ),
        // 🔹 İçerik
        Positioned.fill(
          top: startAfterAppBar ? kToolbarHeight : 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.fabBackground.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fabBackground,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (onUpgrade != null) {
                          onUpgrade!();
                        } else {
                          _openPremiumScreen(context);
                        }
                      },
                      child: Text(
                        loc.premiumButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
