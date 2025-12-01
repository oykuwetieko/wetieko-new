import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class PhotoPickerSheet extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const PhotoPickerSheet({
    super.key,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = AppColors.textFieldBorder.withOpacity(0.5); // Hafif gri çizgi
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.onboardingBackground, // 👈 Tema uyumlu arka plan
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Başlık ve kapat butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onClose,
                icon: Icon(Icons.close, color: AppColors.closeButtonIcon),
              ),
              Text(
                localizations.changeProfilePhoto,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.onboardingTitle,
                ),
              ),
              const SizedBox(width: 48), // Simetri için
            ],
          ),
          ListTile(
            title: Center(
              child: Text(
                localizations.selectFromGallery,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: onPickGallery,
          ),
          Divider(color: dividerColor, height: 1),
          ListTile(
            title: Center(
              child: Text(
                localizations.takePhoto,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: onPickCamera,
          ),
          Divider(color: dividerColor, height: 1),
          ListTile(
            title: Center(
              child: Text(
                localizations.deletePhoto,
                style: const TextStyle(
                  color: Colors.red, // Sabit olarak bırakıldı (önerilen)
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
