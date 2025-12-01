import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/12_profile_view_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/user_model.dart';

class ProfileSearchList extends StatefulWidget {
  final String searchQuery;
  const ProfileSearchList({super.key, this.searchQuery = ''});

  @override
  State<ProfileSearchList> createState() => _ProfileSearchListState();
}

class _ProfileSearchListState extends State<ProfileSearchList> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserStateNotifier>().fetchAllUsers();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = context.watch<UserStateNotifier>();
    final List<User> allUsers = userNotifier.allUsers;
    final String? currentUserId = userNotifier.state.user?.id;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredUsers = allUsers.where((u) {
      if (u.id == currentUserId) return false; // kendini gösterme
      final query = widget.searchQuery.toLowerCase();
      return u.name.toLowerCase().contains(query) ||
          u.location.toLowerCase().contains(query) ||
          (u.industry.isNotEmpty &&
              u.industry.join(', ').toLowerCase().contains(query));
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          "Kullanıcı bulunamadı",
          style: TextStyle(color: AppColors.neutralText),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: filteredUsers.length,
      separatorBuilder: (_, __) => Divider(
        color: AppColors.neutralGrey.withOpacity(0.25),
        height: 16,
      ),
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileViewScreen(externalUser: user),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (user.profileImage != null && user.profileImage!.isNotEmpty)
                      ? Image.network(
                          user.profileImage!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: AppColors.bottomNavBackground.withOpacity(0.1),
                              child: const Icon(
                                Icons.person_outline,
                                size: 20,
                                color: AppColors.bottomNavBackground,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.bottomNavBackground.withOpacity(0.1),
                              child: const Icon(
                                Icons.person_outline,
                                size: 20,
                                color: AppColors.bottomNavBackground,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.bottomNavBackground.withOpacity(0.1),
                          child: const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: AppColors.bottomNavBackground,
                          ),
                        ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralDark,
                  height: 1.1,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "${user.location} · ${user.industry.isNotEmpty ? user.industry.first : ''}",
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.neutralText,
                    height: 1.2,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.categoryInactiveText,
              ),
            ),
          ),
        );
      },
    );
  }
}
