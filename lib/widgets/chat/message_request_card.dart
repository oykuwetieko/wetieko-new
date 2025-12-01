import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';

class MessageRequestCard extends StatelessWidget {
  final String senderName;
  final String? requestId; // ✅ backend'e göndermek için ID
  final void Function(String requestId)? onAccept; // ✅ kabul callback'i
  final VoidCallback onDecline; // ✅ artık "Kısıtla" işlevinde kullanılacak

  const MessageRequestCard({
    super.key,
    required this.senderName,
    this.requestId,
    this.onAccept,
    required this.onDecline,
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
          // 🔸 Kullanıcı adı
          Text(
            senderName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),

          // 🔸 Açıklama metni
          Text(
            loc.chatRequestMessage,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 22),

          // 🔹 Buton grubu
          Row(
            children: [
              // 🚫 Kısıtla (önceden "Reddet")
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white.withOpacity(0.06),
                  ),
                  child: Text(
                    loc.restrict, // 🔹 “Kısıtla” çevirisini kullan
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

              // ✅ Kabul Et
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (onAccept != null && requestId != null) {
                      onAccept!(requestId!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    loc.accept,
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
