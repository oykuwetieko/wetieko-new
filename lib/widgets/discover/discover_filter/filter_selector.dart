import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/theme/text_styles.dart';
import 'package:Wetieko/widgets/discover/discover_filter/section_title.dart';
import 'package:Wetieko/data/constants/city_list.dart';

class FilterSelector extends StatelessWidget {
  final String type;
  final Set<int>? selectedIndices;
  final int? selectedIndex;
  final void Function(int index, bool isSelected)? onToggle;
  final void Function(int index)? onSelect;
  final List<String>? options; // ✅ dışarıdan (JSON’dan) gelen veriler

  const FilterSelector({
    Key? key,
    required this.type,
    this.selectedIndices,
    this.selectedIndex,
    this.onToggle,
    this.onSelect,
    this.options,
  }) : super(key: key);

  bool get isMultiSelect => selectedIndices != null && onToggle != null;

  String getSectionTitle(AppLocalizations loc) {
    switch (type) {
      case 'city':
        return loc.cities;
      case 'sector':
        return loc.sectors;
      case 'gender':
        return loc.gender;
      case 'feature':
        return loc.environmentFeatures;
      case 'experience':
        return loc.experienceLevel;
      case 'eventFeature':
        return loc.eventFeatures;
      default:
        return '';
    }
  }

  List<String> getDefaultOptions(AppLocalizations loc) {
    switch (type) {
      case 'city':
        return cityList;
      case 'experience':
        return [
          loc.teamLead,
          loc.junior,
          loc.founder,
          loc.midLevel,
          loc.senior,
          loc.manager,
        ];
      case 'feature':
        return [
          loc.suitableForMeeting,
          loc.openAir,
          loc.petFriendly,
          loc.parking,
          loc.view,
        ];
      case 'eventFeature':
        return [
          loc.speaker,
          loc.workshop,
          loc.certificate,
          loc.free,
          loc.catering,
          loc.raffle,
          loc.gift,
          loc.openSpace,
          loc.seatAndTable,
          loc.photoVideo,
        ];
      case 'gender':
        return [loc.female, loc.male, loc.preferNotToSay];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // ✅ Eğer dışarıdan options (örneğin JSON’dan gelen sektörler) geldiyse onu kullan
    final optionList = (options != null && options!.isNotEmpty)
        ? options!
        : getDefaultOptions(loc);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getSectionTitle(loc).isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: SectionTitle(text: getSectionTitle(loc)),
            ),
            const SizedBox(height: 20),
          ],
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(optionList.length, (index) {
              final isSelected = isMultiSelect
                  ? selectedIndices!.contains(index)
                  : selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  if (isMultiSelect) {
                    onToggle!(index, isSelected);
                  } else {
                    onSelect!(index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.categoryInactiveBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.categoryInactiveText.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    optionList[index],
                    style: AppTextStyles.textFieldText.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.categoryInactiveText,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
