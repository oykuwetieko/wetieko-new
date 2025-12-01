import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';
import 'package:Wetieko/core/extensions/place_hours_extension.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart'; 

class NearbyWorkplaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  final bool showFavoriteIcon;

  const NearbyWorkplaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.showFavoriteIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final weekdayText = place.weekdayText;
    bool isOpen = false;
    DateTime? openTime;
    DateTime? closeTime;

    if (weekdayText.isNotEmpty) {
      isOpen = weekdayText.isOpenNow;
      (openTime, closeTime) = weekdayText.getOpenCloseTimes();
    }

    String statusText = loc.unknown;

    if (openTime != null && closeTime != null) {
      final formattedOpen = _formatTime(openTime);
      final formattedClose = _formatTime(closeTime);

      statusText = isOpen
          ? '${loc.statusOpen} • $formattedClose ${loc.statusClosing}'
          : '${loc.statusClosed} • $formattedOpen ${loc.statusOpening}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: place.imageUrl != null
                    ? Image.network(
                        place.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image, size: 40)),
                      )
                    : Container(color: Colors.grey[300]),
              ),
            ),
            // Bilgiler
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onboardingTitle,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.ratingStar.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 10, color: AppColors.ratingStar),
                            const SizedBox(width: 2),
                            Text(
                              (place.rating ?? 0.0).toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ratingStar,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  if (place.district != null)
                    _infoRow(Icons.near_me_rounded, place.district!, fontSize: 11),
                  const SizedBox(height: 3),

                  _infoRow(
                    Icons.payments_rounded,
                    place.priceLevel.toPriceLabel, // ✅ EXTENSION KULLANILDI
                    fontSize: 11,
                  ),
                  const SizedBox(height: 3),

                  _infoRow(
                    isOpen ? Icons.lock_open : Icons.lock,
                    statusText,
                    fontSize: 11,
                    iconColor: isOpen ? AppColors.primary : AppColors.logoutButtonBackground,
                  ),

                  if (showFavoriteIcon)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.Hm().format(time);
  }

  Widget _infoRow(IconData icon, String text, {double fontSize = 9, Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 11, color: iconColor ?? AppColors.primary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.textFieldText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
