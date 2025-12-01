import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ActivityJoinButton extends StatelessWidget {
  final int remainingSeats;
  final VoidCallback? onJoin;
  final String? buttonLabel;
  final bool isDisabled;

  const ActivityJoinButton({
    super.key,
    required this.remainingSeats,
    required this.onJoin,
    this.buttonLabel,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final displayText =
        buttonLabel ?? (isDisabled ? loc.eventCompleted : loc.join);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.tagBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            /// Sol Bilgi Alanı
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.activityJoinQuestion,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onboardingTitle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary, // ✅ sabit renk
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        loc.seatsLeft(remainingSeats),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onboardingSubtitle, // ✅ sabit renk
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Sağdaki Katıl Butonu
            ElevatedButton.icon(
              onPressed: isDisabled ? null : onJoin,
              icon: Icon(
                isDisabled ? Icons.event_busy : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(
                displayText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return AppColors.logoutButtonBackground; // 🔴 devre dışı rengi
                  }
                  return AppColors.primary; // 🟢 aktif rengi
                }),
                foregroundColor: MaterialStateProperty.all(
                  AppColors.onboardingButtonText,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
