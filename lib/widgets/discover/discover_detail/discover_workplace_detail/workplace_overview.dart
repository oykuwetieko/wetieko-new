import 'package:flutter/material.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/extensions/place_hours_extension.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart';
import 'package:Wetieko/widgets/common/map_options_bottom_sheet.dart';

class WorkplaceOverview extends StatelessWidget {
  final Place place;

  const WorkplaceOverview({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final bool isOpen = place.weekdayText.isOpenNow;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Açık / Fiyat / Puan rozetleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusBadge(context, isOpen),
              Row(
                children: [
                  _priceBadge(place.priceLevel),
                  const SizedBox(width: 8),
                  _ratingBadge(place.rating ?? 0.0),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Minimalist Başlık + Adres + Map Butonu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık + Adres
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onboardingTitle,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Adres satırı
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            place.formattedAddress ?? '-', // ✅ null kontrol
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: AppColors.onboardingSubtitle,
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // Map butonu
              _MapActionButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => MapOptionsBottomSheet(place: place),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, bool isOpen) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: isOpen ? Colors.green : Colors.red),
          const SizedBox(width: 6),
          Text(
            isOpen ? local.currentlyOpen : local.currentlyClosed,
            style: TextStyle(
              color: isOpen ? Colors.green.shade800 : Colors.red.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ratingStar.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: AppColors.ratingStar),
          const SizedBox(width: 4),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            priceLevel.toPriceLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MapActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Harita seçenekleri',
      child: Material(
        color: AppColors.primary.withOpacity(0.10),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            child: const Center(
              child: Icon(
                Icons.near_me_rounded,
                size: 22,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
