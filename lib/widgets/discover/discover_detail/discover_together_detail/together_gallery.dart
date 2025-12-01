import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/image_preview_viewer.dart'; // ✅ eklendi

class TogetherGallery extends StatefulWidget {
  final List<String> galleryImages;
  final bool isNetworkImages;

  const TogetherGallery({
    super.key,
    required this.galleryImages,
    this.isNetworkImages = false,
  });

  @override
  State<TogetherGallery> createState() => _TogetherGalleryState();
}

class _TogetherGalleryState extends State<TogetherGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.galleryImages;

    return Stack(
      children: [
        /// 📸 Galeri sayfa görünümü
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (_, index) {
              final image = images[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque, // ✅ tüm alan tıklanabilir
                onTap: () {
                  // 🔹 Tam ekran popup göster
                  ImagePreviewViewer.show(context, images, initialIndex: index);
                },
                child: Hero(
                  tag: 'together-image-$image',
                  child: widget.isNetworkImages
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        )
                      : Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
              );
            },
          ),
        ),

        /// 🔙 Geri butonu
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

        /// 🔘 Sayfa göstergesi (alt)
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: List.generate(images.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 8,
                width: isActive ? 20 : 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
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
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
