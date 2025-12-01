import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart';

class WorkplaceOverview extends StatelessWidget {
  final Place place;

  const WorkplaceOverview({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ratingBadge(place.rating ?? 0.0),
            const SizedBox(width: 12),
            _priceBadge(place.priceLevel),
          ],
        ),
        const SizedBox(height: 30),
        // Çalışma koşulları kaldırıldı.
      ],
    );
  }

  Widget _ratingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ratingStar.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: AppColors.ratingStar),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ratingStar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceBadge(int? priceLevel) {
    final level = priceLevel ?? 2;
    final color = Colors.green.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            level.toPriceLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
