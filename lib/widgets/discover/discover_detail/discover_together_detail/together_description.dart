import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class TogetherDescription extends StatelessWidget {
  final String description;

  const TogetherDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Text(
        description,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.onboardingSubtitle,
        ),
      ),
    );
  }
}
