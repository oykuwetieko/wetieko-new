import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 10,
        color: AppColors.textFieldBorder, // Arka plan: açık gri (nötr)
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              color: AppColors.stepBar, // İlerleme rengi: soft mavi
            ),
          ),
        ),
      ),
    );
  }
}
