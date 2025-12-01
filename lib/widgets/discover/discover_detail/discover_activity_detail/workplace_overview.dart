import 'package:flutter/material.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart';

class WorkplaceOverview extends StatelessWidget {
  final EventModel event;

  const WorkplaceOverview({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final rating = event.place.rating;
    final priceLabel = event.place.priceLevel.toPriceLabel;

    return Row(
      children: [
        if (rating != null) _ratingBadge(rating),
        const SizedBox(width: 12),
        _priceBadge(priceLabel),
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

  Widget _priceBadge(String label) {
    final color = Colors.green.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_money, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
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
