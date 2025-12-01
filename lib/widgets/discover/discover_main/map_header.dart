import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/widgets/discover/discover_main/discover_filter_button.dart';
import 'package:Wetieko/screens/03_discover_screen/06_discover_search_screen.dart';
import 'package:Wetieko/models/place_model.dart';

class MapHeader extends StatelessWidget {
  final VoidCallback? onListPressed;
  final String selectedCategory;
  final List<Place> places; // ✅ Zorunlu parametre eklendi

  const MapHeader({
    super.key,
    this.onListPressed,
    required this.selectedCategory,
    required this.places, // ✅ Ekle
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiscoverSearchScreen(
                          showUsers: selectedCategory != loc.places,
                          places: places, // ✅ Zorunlu parametre gönderildi
                        ),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hintText: loc.whereDoYouWantToWorkToday,
                      icon: Icons.search,
                      textColor: AppColors.neutralLight,
                      hintTextColor: AppColors.neutralLight,
                      iconColor: AppColors.neutralLight,
                      borderColor: AppColors.neutralGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DiscoverFilterButton(selectedCategory: selectedCategory),
              const SizedBox(width: 8),
              Material(
                color: AppColors.neutralGrey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onListPressed,
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.list,
                      size: 22,
                      color: AppColors.neutralLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
