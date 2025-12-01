import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkingConditionSelector extends StatelessWidget {
  
  final Map<String, int> values;


  final void Function(String key, int newValue) onChanged;

  const WorkingConditionSelector({
    Key? key,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    const keys = [
      'wifi',
      'socket',
      'silence',
      'workDesk',
      'lighting',
      'ventilation',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: local.workingConditions),
        const SizedBox(height: 20),
        ...keys.map((key) {
          final value = (values[key] ?? 3).clamp(1, 5);
          final label = _getLocalizedLabel(local, key);

          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.textFieldText
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    _roundedButton(Icons.remove, () {
                      if (value > 1) onChanged(key, value - 1);
                    }),
                    const SizedBox(width: 12),
                    Text(
                      '$value',
                      style: AppTextStyles.textFieldText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _roundedButton(Icons.add, () {
                      if (value < 5) onChanged(key, value + 1);
                    }),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getLocalizedLabel(AppLocalizations local, String key) {
    switch (key) {
      case 'wifi':
        return local.wifi;
      case 'socket':
        return local.socket;
      case 'silence':
        return local.silence;
      case 'workDesk':
        return local.workDesk;
      case 'lighting':
        return local.lighting;
      case 'ventilation':
        return local.ventilation;
      default:
        return key;
    }
  }

  Widget _roundedButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.categoryInactiveBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.textFieldText),
      ),
    );
  }
}
