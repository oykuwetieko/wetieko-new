import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/data/constants/city_list.dart';

class CityDropDown extends StatelessWidget {
  final Function(String) onSelectCity;
  final VoidCallback onClose;

  const CityDropDown({
    super.key,
    required this.onSelectCity,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = AppColors.textFieldBorder.withOpacity(0.5);
    final loc = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: AppColors.onboardingBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: Icon(Icons.close, color: AppColors.closeButtonIcon),
                ),
                Text(
                  loc.selectCity,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.onboardingTitle,
                  ),
                ),
                const SizedBox(width: 48), // Icon kadar boşluk
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 30),
                itemCount: cityList.length,
                separatorBuilder: (context, index) => Divider(
                  color: dividerColor,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final city = cityList[index];
                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    title: Center(
                      child: Text(
                        city,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTap: () => onSelectCity(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
