import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/user_model.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_people_dropdown.dart';
import 'package:Wetieko/screens/08_premium_screen/01_premium_offer_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';

class WorkplaceCheckinCard extends StatelessWidget {
  final List<User> attendees;
  final VoidCallback onSelect;
  final bool isDisabled;

  const WorkplaceCheckinCard({
    super.key,
    required this.attendees,
    required this.onSelect,
    this.isDisabled = false,
  });

  Widget _buildAvatar({double size = 40, String? imageUrl}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
        ),
      ),
      child: Center(
        child: Container(
          width: size - 4,
          height: size - 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: (imageUrl != null && imageUrl.trim().isNotEmpty)
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: size * 0.55,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: size * 0.55,
                  ),
          ),
        ),
      ),
    );
  }

  /// İnsan listesi modal
  void _openPeopleDropdown(BuildContext context, List<User> people) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => WorkplacePeopleDropdown(
        people: people,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  /// Premium kontrol + aksiyon
  Future<void> _handlePeopleTap(BuildContext context, List<User> attendees) async {
    final userState = context.read<UserStateNotifier>();
    final isPremium = userState.user?.isPremium ?? false;

    if (!isPremium) {
      final upgraded = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PremiumOfferScreen()),
      );

      // Premium alındıysa veya artık premium olduysa dropdown aç
      final nowPremium = context.read<UserStateNotifier>().user?.isPremium ?? false;
      if (upgraded == true || nowPremium) {
        _openPeopleDropdown(context, attendees);
      }
    } else {
      _openPeopleDropdown(context, attendees);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final uniqueAttendees = {for (var u in attendees) u.id: u}.values.toList();
    final visibleAvatars = uniqueAttendees.take(4).toList();
    final extraCount = uniqueAttendees.length > 4 ? uniqueAttendees.length - 4 : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neutralGrey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (uniqueAttendees.isEmpty)
              Center(
                child: Text(
                  l10n.noOneHereYet,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralGrey,
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                    width: 160,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(
                        visibleAvatars.length,
                        (index) => Positioned(
                          left: index * 30,
                          child: _buildAvatar(
                            size: 44,
                            imageUrl: visibleAvatars[index].profileImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _handlePeopleTap(context, uniqueAttendees),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            extraCount > 0
                                ? "+$extraCount ${l10n.wetiekoPeopleHere}"
                                : "${uniqueAttendees.length} ${l10n.wetiekoPeopleHere}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              onPressed: () {
                if (isDisabled) {
                  CustomAlert.show(
                    context,
                    title: l10n.checkInTitle,
                    description: l10n.checkInDescription,
                    icon: Icons.error_outline_rounded,
                    confirmText: l10n.ok,
                    onConfirm: () {},
                  );
                } else {
                  onSelect();
                }
              },
              icon: const Icon(Icons.place, size: 22, color: Colors.white),
              label: Text(
                isDisabled ? l10n.alreadyCheckedIn : l10n.imHereToo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
