import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/profile_settings/unrestrict_button.dart';

class RestrictedUserCard extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;
  final VoidCallback? onUnrestrict;
  final VoidCallback? onTap;

  const RestrictedUserCard({
    super.key,
    required this.name,
    required this.username,
    required this.imageUrl,
    this.onUnrestrict,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.tagBackground, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Sol kısım (profil + bilgiler)
            Row(
              children: [
                ClipOval(
                  child: imageUrl.isEmpty
                      ? const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person,
                              color: Colors.white, size: 28),
                        )
                      : Image.network(
                          imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 28),
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 28),
                            );
                          },
                        ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.neutralText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),

            // 🔹 Sağ tarafta "Kısıtlamayı Kaldır" butonu
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: UnrestrictButton(onPressed: onUnrestrict),
            ),
          ],
        ),
      ),
    );
  }
}
