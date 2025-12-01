import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath; // nullable
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    this.size = 48,
    this.onTap,
  });

  Widget _placeholderAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Icon(
        Icons.person,
        color: AppColors.primary,
        size: size * 0.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget avatarContent;

    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http')) {
        // ✅ Network image with loading placeholder + key (rebuild için)
        avatarContent = ClipOval(
          child: Image.network(
            imagePath!,
            key: ValueKey(imagePath), // cache-buster değişince rebuild
            width: size,
            height: size,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Yükleme tamamlandı
              }
              return _placeholderAvatar(); // Yüklenirken placeholder
            },
            errorBuilder: (context, error, stackTrace) {
              return _placeholderAvatar(); // Yüklenemezse placeholder
            },
          ),
        );
      } else if (File(imagePath!).existsSync()) {
        avatarContent = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(File(imagePath!)),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        avatarContent = _placeholderAvatar();
      }
    } else {
      avatarContent = _placeholderAvatar();
    }

    return onTap != null
        ? GestureDetector(onTap: onTap, child: avatarContent)
        : avatarContent;
  }
}
