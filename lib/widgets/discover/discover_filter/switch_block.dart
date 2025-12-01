import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';


class SwitchBlock extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final Widget child;

  const SwitchBlock({
    Key? key,
    required this.enabled,
    required this.onToggle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: AppColors.primary,
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: enabled ? 1.0 : 0.4,
          child: IgnorePointer(
            ignoring: !enabled,
            child: child,
          ),
        ),
      ],
    );
  }
}
