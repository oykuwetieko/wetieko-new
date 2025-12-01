import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const CloseButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: onPressed ?? () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.closeButtonBackground,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03), // Hafif gölge
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.close,
              size: 24,
              color: AppColors.closeButtonIcon,
            ),
          ),
        ),
      ),
    );
  }
}
