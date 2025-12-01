import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ModalDragHandle extends StatelessWidget {
  const ModalDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        margin: const EdgeInsets.only(top: 16, bottom: 24), // 🔹 bir tık aşağıda
        decoration: BoxDecoration(
          color: AppColors.neutralDark.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
