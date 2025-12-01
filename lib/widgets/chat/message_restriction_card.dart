import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class MessageRestrictionCard extends StatelessWidget {
  final String userName; // 🔹 Kısıtlanan kullanıcının adı
  final VoidCallback onDelete; // 🗑️ Mesaj silme callback
  final VoidCallback onUnrestrict; // 🔓 Kısıtlamayı kaldırma callback

  const MessageRestrictionCard({
    super.key,
    required this.userName,
    required this.onDelete,
    required this.onUnrestrict,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: AppColors.fabBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🧩 Başlık
          Text(
            loc.unrestrictUserTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),

          // 💬 Açıklama
          Text(
            loc.unrestrictUserSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          // 🔹 Buton grubu
          Row(
            children: [
              // ❌ Mesajı Sil
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white.withOpacity(0.06),
                  ),
                  child: Text(
                    loc.delete, // Çok dilli “Sil”
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // 🔓 Kısıtlamayı Kaldır
              Expanded(
                child: ElevatedButton(
                  onPressed: onUnrestrict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    loc.unrestrict, // Çok dilli “Kısıtlamayı Kaldır”
                    style: TextStyle(
                      color: AppColors.fabBackground,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Divider(
            height: 26,
            thickness: 0.6,
            color: Colors.white.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
