import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/profile_settings/restricted_user_card.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/states/restriction_state_notifier.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/models/user_model.dart';

class RestrictedUsersScreen extends StatefulWidget {
  const RestrictedUsersScreen({super.key});

  @override
  State<RestrictedUsersScreen> createState() => _RestrictedUsersScreenState();
}

class _RestrictedUsersScreenState extends State<RestrictedUsersScreen> {
  @override
  void initState() {
    super.initState();
    // 🔹 Ekran açıldığında kısıtlı kullanıcılar yüklenir
    Future.microtask(() {
      context.read<RestrictionStateNotifier>().fetchRestrictedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final restrictionNotifier = context.watch<RestrictionStateNotifier>();
    final restrictedUsers = restrictionNotifier.restricted;
    final loading = restrictionNotifier.loading;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: loc.restrictedUsers,
        showStepBar: false,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : restrictedUsers.isEmpty
              ? const EmptyStateWidget(type: EmptyStateType.noData)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: restrictedUsers.length,
                  itemBuilder: (context, index) {
                    final user = restrictedUsers[index];
                    final blockedUser = user['blocked'];

                    if (blockedUser == null) return const SizedBox.shrink();

                    // 🔹 Map → User modeline dönüştür
                    final userModel = User.fromJson(blockedUser);

                    final name = userModel.name.isNotEmpty
                        ? userModel.name
                        : 'Bilinmeyen';
                    final location = userModel.location.isNotEmpty
                        ? userModel.location
                        : '-';
                    final imageUrl = userModel.profileImage ?? '';

                    return RestrictedUserCard(
                      name: name,
                      username: location,
                      imageUrl: imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProfileViewScreen(externalUser: userModel),
                          ),
                        );
                      },
                      onUnrestrict: () {
                        // ✅ Artık userName parametresi yok
                        // ✅ İki butonlu CustomAlert
                        CustomAlert.show(
                          context,
                          title: loc.unrestrictUserTitle,
                          description: loc.unrestrictUserSubtitle,
                          icon: Icons.lock_open_rounded,
                          confirmText: loc.approve,
                          cancelText: loc.cancel,
                          isDestructive: true,
                          // 🔹 Onay butonu
                          onConfirm: () async {
                            await context
                                .read<RestrictionStateNotifier>()
                                .unrestrictUser(userModel.id);
                          },
                          // 🔹 İptal butonu
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
