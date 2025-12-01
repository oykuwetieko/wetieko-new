import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/core/extensions/place_address_extension.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/widgets/common/image_preview_viewer.dart'; // ✅ eklendi

class WorkplaceReviewCard extends StatelessWidget {
  final String userName;
  final String review;
  final String imagePath; // profil fotoğrafı
  final String? reviewPhotoUrl; // 📌 eklenen yorum fotoğrafı
  final DateTime reviewDate;
  final Map<String, int> ratings;
  final String? placeAddress;
  final String? userTitle;
  final bool showAvatar;
  final bool showDelete;
  final VoidCallback? onDelete;

  // ✅ Yeni: User objesi
  final User? user;

  // ✅ Opsiyonel: Kendi override edilebilir callback
  final VoidCallback? onUserTap;

  const WorkplaceReviewCard({
    super.key,
    required this.userName,
    required this.review,
    required this.imagePath,
    required this.reviewDate,
    required this.ratings,
    this.placeAddress,
    this.userTitle,
    this.reviewPhotoUrl,
    this.showAvatar = true,
    this.showDelete = false,
    this.onDelete,
    this.user,
    this.onUserTap,
  });

  String _timeAgo(BuildContext context, DateTime date) {
    final loc = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(date);

    if (diff.inDays >= 1) return '${diff.inDays} ${loc.daysAgo}';
    if (diff.inHours >= 1) return '${diff.inHours} ${loc.hoursAgo}';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} ${loc.minutesAgo}';
    return loc.justNow;
  }

  void _handleUserTap(BuildContext context) {
    if (onUserTap != null) {
      onUserTap!();
    } else if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileViewScreen(externalUser: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconKeys = [
      'wifi',
      'socket',
      'silence',
      'workDesk',
      'lighting',
      'ventilation'
    ];

    final displayAddress = (placeAddress != null && placeAddress!.isNotEmpty)
        ? placeAddress!.formattedShortAddress
        : (userTitle ?? 'Adres bilinmiyor');

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tagBackground,
          width: 1.6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ÜST BİLGİ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showAvatar) ...[
                GestureDetector(
                  onTap: () => _handleUserTap(context),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: imagePath.startsWith('http')
                        ? NetworkImage(imagePath)
                        : null,
                    backgroundColor: AppColors.tagBackground,
                    child: !imagePath.startsWith('http')
                        ? const Icon(Icons.person, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleUserTap(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onboardingTitle,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayAddress,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFieldText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _timeAgo(context, reviewDate),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textFieldText,
                    ),
                  ),
                  if (showDelete) const SizedBox(height: 4),
                  if (showDelete)
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.logoutButtonBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.deleteComment ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.logoutButtonBackground,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// PUANLAR
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: iconKeys.where((key) => ratings[key] != null).map((key) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getCategoryIcon(key),
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${ratings[key]}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          /// YORUM veya FOTOĞRAF
          if (review.isNotEmpty) ...[
            Text(
              review,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.neutralDark,
              ),
            ),
            if (reviewPhotoUrl != null && reviewPhotoUrl!.isNotEmpty) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  ImagePreviewViewer.show(context, [reviewPhotoUrl!]); // ✅ popup açar
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    reviewPhotoUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ] else if (reviewPhotoUrl != null && reviewPhotoUrl!.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                ImagePreviewViewer.show(context, [reviewPhotoUrl!]); // ✅ popup açar
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  reviewPhotoUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String key) {
    const iconMap = {
      'wifi': Icons.wifi,
      'socket': Icons.power,
      'silence': Icons.timer,
      'workDesk': Icons.table_bar,
      'lighting': Icons.light_mode,
      'ventilation': Icons.ac_unit,
    };
    return iconMap[key] ?? Icons.star_border;
  }
}
