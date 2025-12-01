import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart';

class FilterSlider extends StatelessWidget {
  final String type;
  final double value;
  final ValueChanged<double> onChanged;

  const FilterSlider({
    Key? key,
    required this.type,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    double min = 0;
    double max = 100;
    int divisions = 5;
    String title = loc.value;
    String? valueLabel;

    switch (type) {
      case 'age':
        min = 18;
        max = 50;
        divisions = 6;
        title = loc.age;
        valueLabel = value.toInt().toString();
        break;
      case 'price':
        min = 0;
        max = 4;
        divisions = 4;
        title = loc.price;
        valueLabel = (value.toInt()).toPriceLabel;
        break;
      case 'participant':
        min = 0;
        max = 20;
        divisions = 4;
        title = loc.participantCount;
        valueLabel = value.toInt().toString();
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: title),
        const SizedBox(height: 12),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel, // Tooltip için gerekli
          activeColor: AppColors.primary,
          inactiveColor: AppColors.categoryInactiveBackground,
          onChanged: onChanged,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
