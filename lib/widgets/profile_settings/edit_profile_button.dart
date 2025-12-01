import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditProfileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.closeButtonBackground, 
        ),
        child: const Icon(
          Icons.edit,
          color: AppColors.closeButtonIcon, 
          size: 18,
        ),
      ),
    );
  }
}
