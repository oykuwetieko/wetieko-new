import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:Wetieko/core/theme/colors.dart';

class ImagePreviewViewer {
  /// 📸 Artık popup overlay şeklinde açılır
  static void show(BuildContext context, List<String> imageUrls,
      {int initialIndex = 0}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ImagePreview",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, _, __) {
        return _ImagePreviewContent(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value) - 1.0;
        return Transform.translate(
          offset: Offset(0.0, curvedValue * 20),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}

/// 🖼️ Asıl tam ekran zoom-viewer içeriği
class _ImagePreviewContent extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _ImagePreviewContent({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: initialIndex);

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            /// 🔹 Fotoğraflar
            PhotoViewGallery.builder(
              pageController: controller,
              itemCount: imageUrls.length,
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),

              builder: (context, index) {
                final url = imageUrls[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(url),

                  /// 🚫 Google Photo 403 logunu KESEN yer
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white70,
                        size: 60,
                      ),
                    );
                  },

                  heroAttributes: PhotoViewHeroAttributes(tag: url),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3.5,
                );
              },

              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

            /// 🔹 Sağ üst köşedeki Close (X) butonu
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.closeButtonBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.closeButtonIcon,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
