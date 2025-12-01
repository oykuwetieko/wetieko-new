import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class CreateOptionStepBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CreateOptionStepBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;

        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(left: index == 0 ? 0 : 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.neutralGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
