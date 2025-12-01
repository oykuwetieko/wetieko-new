import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnrestrictButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const UnrestrictButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Flexible(
      fit: FlexFit.loose, // 🔹 Genişliği dinamik yapar
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fabBackground,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        child: Text(loc.unrestrict),
      ),
    );
  }
}
