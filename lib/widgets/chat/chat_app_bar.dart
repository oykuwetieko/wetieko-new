import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/models/user_model.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user; // ✅ komple User nesnesi alıyoruz
  final VoidCallback onBack;
  final VoidCallback onDelete;

  const ChatAppBar({
    super.key,
    required this.user,
    required this.onBack,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = user.profileImage ?? '';
    final name = user.name;

    return AppBar(
      backgroundColor: AppColors.fabBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
      titleSpacing: 16,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileViewScreen(
                externalUser: user, // ✅ komple User gönderiyoruz
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, -4),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.tagBackground,
                  foregroundImage: avatar.isNotEmpty && avatar.startsWith("http")
                      ? NetworkImage(avatar)
                      : (avatar.isNotEmpty
                          ? AssetImage(avatar) as ImageProvider
                          : null),
                  child: const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.white,
                  ), // fallback icon
                ),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: onDelete,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
