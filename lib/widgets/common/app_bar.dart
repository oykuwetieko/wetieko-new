import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Wetieko/widgets/onboarding/step_progress_bar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart'; // ✅ Eklendi

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? totalSteps;
  final int? currentStep;
  final bool showStepBar;
  final String? title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final Widget? actionWidget;

  const CustomAppBar({
    super.key,
    this.totalSteps,
    this.currentStep,
    this.showStepBar = false,
    this.title,
    this.actionIcon,
    this.onActionPressed,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.onboardingBackground,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: AppColors.onboardingBackground,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: kToolbarHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🔙 Geri butonu
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 28,
                      color: AppColors.backButton,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationWrapper(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                // 📝 Başlık (Step bar yoksa ortada)
                if (title != null && !showStepBar)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onboardingTitle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // ⬛ Ortalanmış Step Bar
                if (showStepBar && totalSteps != null && currentStep != null)
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: StepProgressBar(
                        totalSteps: totalSteps!,
                        currentStep: currentStep!,
                      ),
                    ),
                  ),

                // 📝 Başlık (Step bar varsa sol üstte)
                if (title != null && showStepBar)
                  Positioned(
                    left: 56,
                    right: 56,
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onboardingTitle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // ⚙️ Sağ widget veya ikon
                if (actionWidget != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: actionWidget,
                    ),
                  )
                else if (actionIcon != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: Icon(actionIcon),
                        iconSize: 24,
                        color: AppColors.onboardingTitle,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onActionPressed,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
