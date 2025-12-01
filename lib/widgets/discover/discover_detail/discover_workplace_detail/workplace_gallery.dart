import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/widgets/common/image_preview_viewer.dart'; // ✅ eklendi

class WorkplaceGallery extends StatefulWidget {
  final Place place;
  final void Function(bool isAdded)? onFavoriteToggled;

  const WorkplaceGallery({
    super.key,
    required this.place,
    this.onFavoriteToggled,
  });

  @override
  State<WorkplaceGallery> createState() => _WorkplaceGalleryState();
}

class _WorkplaceGalleryState extends State<WorkplaceGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.place.allImageUrls;

    return Stack(
      children: [
        /// 📸 Ana Galeri
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (_, index) => GestureDetector(
              behavior: HitTestBehavior.opaque, // ✅ Tüm alan tıklanabilir
              onTap: () {
                ImagePreviewViewer.show(context, images, initialIndex: index);
              },
              child: Hero(
                tag: 'workplace-image-${images[index]}',
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
            ),
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

        /// ❤️ Favori butonu
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 16,
          child: Consumer<PlaceStateNotifier>(
            builder: (context, placeNotifier, _) {
              final isFavorite = placeNotifier.isFavorite(widget.place.id);

              return _circleButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.primary,
                backgroundColor:
                    AppColors.overlayBackground.withOpacity(0.9),
                shadow: true,
                onTap: () async {
                  if (isFavorite) {
                    final success =
                        await placeNotifier.removeFavorite(widget.place.id);
                    if (success) widget.onFavoriteToggled?.call(false);
                  } else {
                    final success =
                        await placeNotifier.addFavorite(widget.place.id);
                    if (success) widget.onFavoriteToggled?.call(true);
                  }
                },
              );
            },
          ),
        ),

        /// 🔘 Sayfa göstergesi
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
