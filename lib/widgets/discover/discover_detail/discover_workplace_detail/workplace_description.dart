import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart'; 

class WorkplaceDescription extends StatelessWidget {
  final String description;

  const WorkplaceDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Text(
        description,
        textAlign: TextAlign.justify, 
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.onboardingTitle, 
          height: 1.5,
        ),
      ),
    );
  }
}
