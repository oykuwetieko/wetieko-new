import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ProfileViewGallery extends StatefulWidget {
  final List<String> galleryImages;

  const ProfileViewGallery({super.key, required this.galleryImages});

  @override
  State<ProfileViewGallery> createState() => _ProfileViewGalleryState();
}

class _ProfileViewGalleryState extends State<ProfileViewGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.galleryImages;

    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (_, index) => Hero(
              tag: 'profile-image-${images[index]}',
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        // 🔙 Sol üstte geri butonu
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          child: _circleButton(
            icon: Icons.arrow_back,
            color: Colors.white,
            backgroundColor: AppColors.primary,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        // 📤 Sağ üstte paylaş butonu
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 16,
          child: _circleButton(
            icon: Icons.share,
            color: AppColors.primary,
            backgroundColor: AppColors.overlayBackground.withOpacity(0.9),
            shadow: true,
            onTap: () {
              // Paylaşma işlemi burada
              debugPrint('Paylaşa tıklandı');
            },
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required Color backgroundColor,
    bool shadow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
