import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class AddButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddButtonWidget({super.key, this.onPressed}); // ← onPressed eklendi

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 48,
      right: 24,
      child: GestureDetector(
        onTap: onPressed, // ← burada kullanıldı
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.nextButton,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 28,
              color: AppColors.onboardingButtonText,
            ),
          ),
        ),
      ),
    );
  }
}
