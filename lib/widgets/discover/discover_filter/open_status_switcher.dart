import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenStatusSwitch extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool> onChanged;

  const OpenStatusSwitch({
    Key? key,
    required this.isOpen,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: local.venueStatus), 
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(local.onlyOpenVenues, style: AppTextStyles.textFieldText), 
            Switch(
              value: isOpen,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
