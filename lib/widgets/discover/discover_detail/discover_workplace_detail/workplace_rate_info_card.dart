import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class WorkplaceRateInfoCard extends StatelessWidget {
  final String message;

  const WorkplaceRateInfoCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
