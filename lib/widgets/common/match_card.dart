import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/screens/03_discover_screen/01_main_discover_screen.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: screenHeight * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Fotoğraflar ve ışıltılar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: _buildProfileImage("assets/images/nomad_1.png", -8),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: _buildProfileImage("assets/images/nomad_2.png", 8),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      left: 40,
                      child: _Sparkle(color: AppColors.primary),
                    ),
                    const Positioned(
                      top: 10,
                      right: 40,
                      child: _Sparkle(color: AppColors.primary),
                    ),
                    const Positioned(
                      bottom: 15,
                      left: 60,
                      child: _Sparkle(color: AppColors.primary),
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 50,
                      child: _Sparkle(color: AppColors.primary),
                    ),
                  ],
                ),

                // Başlık ve açıklama
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        loc.readyToCollaborateTitle, // 🔁 Lokalize başlık
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        loc.readyToCollaborateSubtitle, // 🔁 Lokalize açıklama
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onboardingSubtitle,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                // Butonlar
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomButton(
                        text: loc.startChat, // 🔁 Lokalize buton
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: AppColors.onboardingButtonBackground,
                        textColor: AppColors.onboardingButtonText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomButton(
                        text: loc.keepExploring, // 🔁 Lokalize buton
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DiscoverScreen(
                                initialCategoryKey: 'collaborateNow',
                              ),
                            ),
                          );
                        },
                        hasBorder: true,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.onboardingTitle,
                        borderColor: AppColors.onboardingTitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildProfileImage(String path, double angle) {
    return Transform.rotate(
      angle: angle * 0.01745,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          path,
          width: 140,
          height: 190,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ⭐ Işıltı bileşeni
class _Sparkle extends StatelessWidget {
  final Color color;
  const _Sparkle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      color: color,
      size: 22,
    );
  }
}
