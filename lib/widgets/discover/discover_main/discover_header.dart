import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/location_tag.dart';
import 'package:Wetieko/widgets/common/notification_buton.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/widgets/discover/discover_main/discover_filter_button.dart';
import 'package:Wetieko/widgets/discover/discover_main/map_view_button.dart';
import 'package:Wetieko/screens/03_discover_screen/05_workplace_map_screen.dart';
import 'package:Wetieko/screens/03_discover_screen/06_discover_search_screen.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/states/app_notification_state_notifier.dart'; // 🆕 ekledik

class DiscoverHeader extends StatelessWidget {
  final String selectedCategory;
  final List<Place> workplaces;

  const DiscoverHeader({
    super.key,
    required this.selectedCategory,
    required this.workplaces,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final userName =
        context.watch<UserStateNotifier>().state.user?.name ?? '';

    String getHeadlineText() {
      if (selectedCategory == loc.workplaces) {
        return loc.whereDoYouWantToWorkToday;
      } else if (selectedCategory == loc.cowork) {
        return loc.whoDoYouWantToWorkWithGroupToday;
      } else if (selectedCategory == loc.activities) {
        return loc.whichDoYouWantToMeetingWithToday;
      } else if (selectedCategory == loc.collaborateNow) {
        return loc.whoDoYouWantToWorkWithToday;
      }
      return '';
    }

    final headline = getHeadlineText();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 250),
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LocationTag(),
                  // 🆕 Bildirim sayısını dinamik olarak alıyoruz
                  Consumer<AppNotificationStateNotifier>(
                    builder: (context, state, _) {
                      final unreadCount =
                          state.unreadSummary['totalUnread'] ?? 0;
                      return NotificationButton(); // artık kendi içinde state dinliyor
                    },
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                'Selam, $userName 👋',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder: (_, __, ___) => DiscoverSearchScreen(
                              showUsers: selectedCategory != loc.workplaces,
                              places: workplaces,
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ));
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: headline,
                          icon: Icons.search,
                          textColor: AppColors.neutralLight,
                          hintTextColor: AppColors.neutralLight,
                          iconColor: AppColors.neutralLight,
                          borderColor: AppColors.neutralGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DiscoverFilterButton(selectedCategory: selectedCategory),
                  const SizedBox(width: 8),
                  MapViewButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkplaceMapScreen(
                            selectedCategory: selectedCategory,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
