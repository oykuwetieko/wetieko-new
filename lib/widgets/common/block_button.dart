import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/states/restriction_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';

class BlockButton extends StatelessWidget {
  final User? targetUser;

  const BlockButton({super.key, this.targetUser});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<RestrictionStateNotifier>();
    final loc = AppLocalizations.of(context)!;

    if (targetUser == null) return const SizedBox.shrink();

    final userId = targetUser!.id;
    final isBlocked = notifier.isBlocked;
    final isLoading = notifier.loading;

    return IconButton(
      onPressed: isLoading
          ? null
          : () {
              if (isBlocked) {
                /// 🔥 Kısıtlamayı KALDIR
                CustomAlert.show(
                  context,
                  title: loc.unrestrictUserTitle,
                  description: loc.unrestrictUserSubtitle,
                  icon: Icons.lock_open_rounded,
                  confirmText: loc.approve,
                  cancelText: loc.cancel,
                  isDestructive: true,
                  onConfirm: () {
                    notifier.unrestrictUser(userId);
                  },
                  onCancel: () {}, // <-- İPTAL butonu için eklendi
                );
              } else {
                /// 🔥 Kısıtla
                CustomAlert.show(
                  context,
                  title: loc.restrictUserTitle,
                  description: loc.restrictUserSubtitle,
                  icon: Icons.block_rounded,
                  confirmText: loc.approve,
                  cancelText: loc.cancel,
                  isDestructive: true,
                  onConfirm: () {
                    notifier.restrictUser(userId);
                  },
                  onCancel: () {}, // <-- İPTAL butonu için eklendi
                );
              }
            },
      icon: isLoading
          ? const CircularProgressIndicator()
          : Icon(
              isBlocked
                  ? Icons.do_not_disturb_on_outlined
                  : Icons.not_interested,
              color:
                  isBlocked ? Colors.redAccent : AppColors.onboardingTitle,
              size: 28,
            ),
    );
  }
}
