import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.textFieldText.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
