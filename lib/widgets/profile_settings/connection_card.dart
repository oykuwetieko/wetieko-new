import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ConnectionCard extends StatelessWidget {
  final String imagePath; // URL ya da asset olabilir, boş olabilir
  final String name;
  final String profession;
  final String city;
  final VoidCallback? onTap;

  /// Sağ üstte “çarpı” butonunu göstermek için
  final VoidCallback? onRemove;

  const ConnectionCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.profession,
    required this.city,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasNetwork = imagePath.startsWith('http');
    final hasImage = imagePath.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.tagBackground,
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            // 👤 Avatar (network yüklenene kadar / yoksa placeholder)
            _buildAvatar(hasImage: hasImage, hasNetwork: hasNetwork),

            const SizedBox(width: 16),

            // 📄 Bilgiler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İsim
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profession,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.bottomNavBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.ratingStar,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          city,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.bottomNavBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Sağ taraf: ya minimalist “X” butonu ya da chevron
            onRemove != null
                ? _miniIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Remove',
                    iconColor: AppColors.categoryInactiveText,
                    onPressed: onRemove,
                  )
                : const Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: AppColors.neutralText,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required bool hasImage, required bool hasNetwork}) {
    if (!hasImage) {
      // Fotoğraf yoksa placeholder
      return _fallbackAvatar();
    }

    if (hasNetwork) {
      // Network image: yüklenene kadar ve hata olursa placeholder
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // yüklendi
            return _fallbackAvatar();
          },
          errorBuilder: (context, error, stackTrace) {
            return _fallbackAvatar();
          },
        ),
      );
    }

    // Asset (veya local bundle): hata olursa placeholder
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackAvatar(),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.categoryInactiveBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: AppColors.neutralText, size: 24),
    );
  }

  // NotificationSummaryCard’daki action butonunun minimalist “çarpı” versiyonu
  Widget _miniIconButton({
    required IconData icon,
    required String tooltip,
    required Color iconColor,
    required VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        splashColor: iconColor.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.categoryInactiveBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.neutralGrey.withOpacity(0.5),
              width: 0.9,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 17,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
