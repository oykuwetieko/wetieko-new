import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool isDestructive; 
  final bool forceRootOverlay; // 🔹 yeni parametre

  const CustomAlert({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.isDestructive = false,
    this.forceRootOverlay = false, // 🔹 default normal
  });

  /// ✅ Overlay ile göster
  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool forceRootOverlay = false, // 🔹 ekledik
  }) {
    OverlayState? overlayState;

    if (forceRootOverlay) {
      // 🔹 Root navigator üzerinden overlay al
      overlayState = Navigator.of(context, rootNavigator: true).overlay;
    } else {
      overlayState = Overlay.of(context, rootOverlay: true);
    }

    if (overlayState == null) {
      debugPrint("❌ Overlay bulunamadı");
      return;
    }

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => CustomAlert(
        title: title,
        description: description,
        icon: icon,
        confirmText: confirmText,
        onConfirm: () {
          entry.remove();
          onConfirm();
        },
        cancelText: cancelText,
        onCancel: onCancel != null
            ? () {
                entry.remove();
                onCancel();
              }
            : null,
        isDestructive: isDestructive,
        forceRootOverlay: forceRootOverlay, // 🔹 ekledik
      ),
    );

    overlayState.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final confirmColor =
        isDestructive ? AppColors.logoutButtonBackground : AppColors.primary;

    return Material(
      color: Colors.black.withOpacity(0.35),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 İkon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: confirmColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: confirmColor,
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Başlık
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDark,
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Açıklama
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.neutralText,
                ),
              ),
              const SizedBox(height: 28),

              // 🔹 Butonlar
              if (cancelText != null && onCancel != null)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: AppColors.neutralDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          cancelText!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: onConfirm,
                        style: TextButton.styleFrom(
                          backgroundColor: confirmColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onConfirm,
                    style: TextButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
