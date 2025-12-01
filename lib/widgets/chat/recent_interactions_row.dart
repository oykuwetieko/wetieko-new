import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/models/user_model.dart';

class RecentInteractionsRow extends StatelessWidget {
  final List<User> users;

  const RecentInteractionsRow({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SizedBox();
    }

    return Container(
      color: AppColors.onboardingBackground,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Başlık l10n ile
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppLocalizations.of(context)!.interactions,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.fabBackground,
              ),
            ),
          ),
          // 🔹 Liste
          SizedBox(
            height: 104,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == users.length - 1 ? 0 : 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileViewScreen(
                            externalUser: user,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // dıştaki halka (primary renkli)
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                            // içte avatar
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.tagBackground,
                              foregroundImage: (user.profileImage != null &&
                                      user.profileImage!.startsWith("http"))
                                  ? NetworkImage(user.profileImage!)
                                  : (user.profileImage != null &&
                                          user.profileImage!.isNotEmpty)
                                      ? AssetImage(user.profileImage!)
                                          as ImageProvider
                                      : null,
                              child: const Icon(
                                Icons.person,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 64,
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onboardingSubtitle,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
