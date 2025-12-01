import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class HeadingText extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign align;

  const HeadingText({
    super.key,
    required this.title,
    required this.subtitle,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAlign;
    switch (align) {
      case TextAlign.left:
        crossAlign = CrossAxisAlignment.start;
        break;
      case TextAlign.right:
        crossAlign = CrossAxisAlignment.end;
        break;
      default:
        crossAlign = CrossAxisAlignment.center;
    }

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(
          title,
          textAlign: align,
          style: AppTextStyles.onboardingTitle,
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: align,
          style: AppTextStyles.onboardingSubtitle,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
