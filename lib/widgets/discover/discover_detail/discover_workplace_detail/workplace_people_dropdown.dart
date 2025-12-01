import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';

class WorkplacePeopleDropdown extends StatelessWidget {
  final List<User> people; // ✅ User listesi
  final VoidCallback onClose;

  const WorkplacePeopleDropdown({
    super.key,
    required this.people,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = AppColors.textFieldBorder.withOpacity(0.5);

    /// ✅ Kullanıcıların tekrar sayılarını hesapla
    final Map<String, int> countMap = {};
    for (final user in people) {
      countMap[user.id] = (countMap[user.id] ?? 0) + 1;
    }

    /// ✅ En çok tekrar eden kullanıcıyı bul
    User? topUser;
    if (countMap.isNotEmpty) {
      final topId =
          countMap.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      topUser = people.firstWhere((u) => u.id == topId);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClose,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // içerik kapanmasın
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onClose,
                      icon: Icon(Icons.close, color: AppColors.closeButtonIcon),
                    ),
                    Text(
                      AppLocalizations.of(context)!.wetiekoPeopleHere,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.onboardingTitle,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 15),

                /// People list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: people.length,
                    separatorBuilder: (context, index) => Divider(
                      color: dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final user = people[index];

                      /// Subtitle güvenli bir şekilde oluşturuluyor
                      final subtitleParts = <String>[
                        if (user.careerPosition.isNotEmpty)
                          user.careerPosition.first,
                        if (user.location != null && user.location!.isNotEmpty)
                          user.location!,
                      ];

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: ClipOval(
                            child: (user.profileImage != null &&
                                    user.profileImage!.trim().isNotEmpty)
                                ? Image.network(
                                    user.profileImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            /// 🏆 Müdavim etiketi (l10n’den)
                            if (topUser != null && topUser.id == user.id)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.emoji_events,
                                        size: 16, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.of(context)!.regular,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          subtitleParts.join(" • "),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.grey, size: 20),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
