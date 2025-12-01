import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class PremiumBackgroundBanner extends StatelessWidget {
  const PremiumBackgroundBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/location_permission.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  AppColors.bottomNavBackground,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
