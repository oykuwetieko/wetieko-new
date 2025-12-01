import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class MapViewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapViewButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralGrey.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: const Icon(
            Icons.map_outlined,
            size: 22,
            color: AppColors.neutralLight,
          ),
        ),
      ),
    );
  }
}
