import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';
import 'package:Wetieko/core/extensions/place_hours_extension.dart';
import 'package:Wetieko/core/extensions/price_level_extension.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

class WorkplaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  final bool showFavoriteIcon;
  final bool showCommentOnly;
  final VoidCallback? onFavoriteRemoved;

  const WorkplaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.showFavoriteIcon = false,
    this.showCommentOnly = false,
    this.onFavoriteRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Card(
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          color: AppColors.cardBackground,
          shadowColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 90,
                        child: SizedBox.expand(
                          child: place.imageUrl != null
                              ? Image.network(
                                  place.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                              : Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    if (showFavoriteIcon)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Consumer<PlaceStateNotifier>(
                          builder: (context, placeNotifier, _) {
                            final isFavorite =
                                placeNotifier.isFavorite(place.id);

                            return GestureDetector(
                              onTap: () async {
                                if (isFavorite) {
                                  CustomAlert.show(
                                    context,
                                    title: loc.removeFromFavoritesTitle,
                                    description:
                                        loc.removeFromFavoritesDescription,
                                    icon: Icons.favorite_border_rounded,
                                    confirmText: loc.remove,
                                    onConfirm: () async {
                                      final success =
                                          await placeNotifier.removeFavorite(
                                              place.id);
                                      if (success) {
                                        onFavoriteRemoved?.call();
                                      }
                                    },
                                    cancelText: loc.cancel,
                                    onCancel: () {},
                                  );
                                } else {
                                  final success =
                                      await placeNotifier.addFavorite(place.id);
                                  if (success) {
                                    CustomAlert.show(
                                      context,
                                      title: loc.favoriteAddedTitle,
                                      description:
                                          '${place.name} ${loc.favoriteAddedMessage}',
                                      icon: Icons.check_circle_rounded,
                                      confirmText: loc.ok,
                                      onConfirm: () {},
                                    );
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.overlayBackground
                                      .withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Mekan adı + puan
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onboardingTitle,
                              ),
                            ),
                          ),
                          if (place.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.ratingStar.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 11, color: AppColors.ratingStar),
                                  const SizedBox(width: 2),
                                  Text(
                                    place.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 11,
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
                      _infoRow(Icons.location_on_rounded,
                          place.formattedAddress),
                      const SizedBox(height: 4),
                      _infoRow(Icons.schedule_rounded,
                          place.weekdayText.getTodayFormattedHours()),
                      const SizedBox(height: 4),
                      _infoRow(Icons.payments_rounded,
                          place.priceLevel.toPriceLabel),

                      /// 🆕 💬 Yorum sayısı — fiyatın hemen altında
                      if (place.feedbackCount != null &&
                          place.feedbackCount! > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.chat_bubble_outline,
                                  size: 11, color: AppColors.primary),
                              const SizedBox(width: 3),
                              Text(
                                '${place.feedbackCount} ${loc.comment}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textFieldText,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 6),
                      if (showCommentOnly &&
                          place.feedbacks != null &&
                          place.feedbacks!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            place.feedbacks!.first.comment ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.neutralDark,
                            ),
                          ),
                        ),
                      if ((place.workingConditionTags +
                              place.spaceFeatureTags)
                          .isNotEmpty)
                        SizedBox(
                          height: 32,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: (place.workingConditionTags +
                                      place.spaceFeatureTags)
                                  .map((tag) {
                                final valueStr =
                                    '${tag.value.toStringAsFixed(1)} / 5';
                                return Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.tagBackground
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(tag.icon,
                                          size: 11, color: AppColors.primary),
                                      const SizedBox(width: 3),
                                      Text(
                                        valueStr,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textFieldText,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Null kontrolü ile infoRow
  Widget _infoRow(IconData icon, String? text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text ?? '-',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textFieldText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
