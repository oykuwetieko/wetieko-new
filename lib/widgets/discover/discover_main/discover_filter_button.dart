import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_main/discover_filter.dart';

class DiscoverFilterButton extends StatelessWidget {
  final String selectedCategory;

  const DiscoverFilterButton({super.key, required this.selectedCategory});

  void _openFilterPanel(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    String filterType;
    if (selectedCategory == loc.workplaces) {
      filterType = 'workplace';
    } else if (selectedCategory == loc.cowork) {
      filterType = 'cowork';
    } else if (selectedCategory == loc.activities) {
      filterType = 'activity';
    } else if (selectedCategory == loc.collaborateNow) {
      filterType = 'togetherWork';
    } else {
      filterType = 'workplace';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.overlayBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8, // Ekranın %90'ı
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DiscoverFilter(
              filterType: filterType,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralGrey.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openFilterPanel(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: const Icon(
            Icons.tune,
            size: 22,
            color: AppColors.neutralLight,
          ),
        ),
      ),
    );
  }
}
