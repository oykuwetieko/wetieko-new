import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:Wetieko/core/theme/colors.dart';

class PremiumPlanOptions extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final ProductDetails? yearlyProduct;
  final ProductDetails? monthlyProduct;

  const PremiumPlanOptions({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.yearlyProduct,
    this.monthlyProduct,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Yıllık plan
        _buildCard(
          title: locale.yearlyPlan,
          tag: locale.bestDeal,
          value: 'yearly',
          context: context,
          product: yearlyProduct,
        ),
        const SizedBox(height: 16),
        // Aylık plan
        _buildCard(
          title: locale.monthlyPlan,
          tag: locale.popularChoice,
          value: 'monthly',
          context: context,
          product: monthlyProduct,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String tag,
    required String value,
    required BuildContext context,
    required ProductDetails? product,
  }) {
    final bool isSelected = selectedValue == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.bottomNavBackground,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.8,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.45),
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol taraf: Başlık + Tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.15)
                              : AppColors.tagBackground.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sağ taraf: Fiyat
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product != null ? product.price : "₺---",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Eğer indirim etiketin olacaksa App Store tarafında intro price’dan okuyabilirsin
        ],
      ),
    );
  }
}
