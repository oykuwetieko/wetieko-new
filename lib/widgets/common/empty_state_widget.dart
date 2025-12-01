import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/screens/04_create_options_screen/01_main_create_options_screen.dart';
import 'package:Wetieko/screens/03_discover_screen/06_discover_search_screen.dart';
import 'package:Wetieko/screens/03_discover_screen/07_discover_workplace_rate.dart';
import 'package:Wetieko/states/place_state_notifier.dart';

enum EmptyStateType {
  profileView,
  newEvent,
  newFollow,
  eventUpdate,
  general,
  newPlace,
  placeUpdate,
  noFavorites,
  noReviews,
  noReviewsWorkplaceDetail,
  noJoinedEvents,
  noFollowers,
  noFollowing,
  noMessages,
  noEvents,
  noCowork,
  noCollab,
  noPlaceWithFeatures,
  noPlacePreferences,
  noData, // ✅ yeni tip eklendi
}

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final Place? place;

  const EmptyStateWidget({super.key, required this.type, this.place});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final config = _getConfig(type, loc);

    final placesList = context.read<PlaceStateNotifier>().places;

    // noData burada yok -> buton çıkmayacak
    final bool showButton = {
      EmptyStateType.profileView,
      EmptyStateType.newEvent,
      EmptyStateType.newFollow,
      EmptyStateType.noFavorites,
      EmptyStateType.noReviews,
      EmptyStateType.noReviewsWorkplaceDetail,
      EmptyStateType.noJoinedEvents,
      EmptyStateType.noFollowers,
      EmptyStateType.noFollowing,
      EmptyStateType.noMessages,
      EmptyStateType.noEvents,
      EmptyStateType.noCowork,
      EmptyStateType.noCollab,
      EmptyStateType.noPlaceWithFeatures,
      EmptyStateType.noPlacePreferences,
    }.contains(type);

    final bool isCompact = {
      EmptyStateType.noEvents,
      EmptyStateType.noCowork,
      EmptyStateType.noCollab,
    }.contains(type);

    final bool goToCreateScreen = {
      EmptyStateType.noEvents,
      EmptyStateType.noCowork,
      EmptyStateType.noCollab,
    }.contains(type);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 72, 32, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              child: Icon(
                config.icon,
                size: isCompact ? 25 : 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCompact ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              config.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCompact ? 13 : 14.5,
                color: AppColors.neutralText,
                height: 1.6,
              ),
            ),
            if (showButton) ...[
              const SizedBox(height: 28),
              TextButton(
                onPressed: () async {
                  if (type == EmptyStateType.noPlaceWithFeatures) {
                    final placeState = context.read<PlaceStateNotifier>();
                    final city = placeState.lastFetchedCity ?? "İstanbul";
                    await placeState.loadPlaces(city: city);
                    return;
                  }

                  if (type == EmptyStateType.noReviewsWorkplaceDetail && place != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiscoverWorkplaceRateScreen(place: place!),
                      ),
                    );
                  } else if (goToCreateScreen ||
                      {
                        EmptyStateType.profileView,
                        EmptyStateType.newEvent,
                        EmptyStateType.newFollow,
                        EmptyStateType.noFollowers,
                      }.contains(type)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationWrapper(initialIndex: 2),
                      ),
                    );
                  } else if (type == EmptyStateType.noFollowing || type == EmptyStateType.noMessages) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiscoverSearchScreen(
                          showUsers: true,
                          places: placesList,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationWrapper(initialIndex: 0),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 20 : 24,
                    vertical: isCompact ? 10 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  backgroundColor: AppColors.primary.withOpacity(0.06),
                ),
                child: Text(
                  type == EmptyStateType.noReviewsWorkplaceDetail
                      ? loc.rateNow
                      : (type == EmptyStateType.noPlaceWithFeatures
                          ? loc.listPlaces
                          : loc.startExploring),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isCompact ? 13 : 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _EmptyStateConfig _getConfig(EmptyStateType type, AppLocalizations loc) {
    switch (type) {
      case EmptyStateType.noData:
        return _EmptyStateConfig(
          icon: Icons.info_outline,
          title: loc.emptyStateTitle,
          subtitle: loc.emptyStateDescription,
        );
      case EmptyStateType.noPlacePreferences:
        return _EmptyStateConfig(
          icon: Icons.store_outlined,
          title: loc.noPlacePreferencesTitle,
          subtitle: loc.noPlacePreferencesSubtitle,
        );
      case EmptyStateType.profileView:
        return _EmptyStateConfig(
          icon: Icons.visibility_outlined,
          title: loc.noOneDiscoveredYou,
          subtitle: loc.increaseVisibility,
        );
      case EmptyStateType.newEvent:
        return _EmptyStateConfig(
          icon: Icons.event_note,
          title: loc.noNewEvents,
          subtitle: loc.fillTheGap,
        );
      case EmptyStateType.newFollow:
        return _EmptyStateConfig(
          icon: Icons.group_off_outlined,
          title: loc.noFollowers,
          subtitle: loc.growAudience,
        );
      case EmptyStateType.eventUpdate:
        return _EmptyStateConfig(
          icon: Icons.event_repeat,
          title: loc.everythingOkEvents.split("\n")[0],
          subtitle: loc.everythingOkEvents.split("\n")[1],
        );
      case EmptyStateType.general:
        return _EmptyStateConfig(
          icon: Icons.notifications_off_outlined,
          title: loc.noActivityYet.split("\n")[0],
          subtitle: loc.noActivityYet.split("\n")[1],
        );
      case EmptyStateType.newPlace:
        return _EmptyStateConfig(
          icon: Icons.map_outlined,
          title: loc.newVenuesComing.split("\n")[0],
          subtitle: loc.newVenuesComing.split("\n")[1],
        );
      case EmptyStateType.placeUpdate:
        return _EmptyStateConfig(
          icon: Icons.place,
          title: loc.everythingOkVenues.split("\n")[0],
          subtitle: loc.everythingOkVenues.split("\n")[1],
        );
      case EmptyStateType.noFavorites:
        return _EmptyStateConfig(
          icon: Icons.favorite_border,
          title: loc.noFavoritesYet.split("\n")[0],
          subtitle: loc.noFavoritesYet.split("\n")[1],
        );
      case EmptyStateType.noReviews:
      case EmptyStateType.noReviewsWorkplaceDetail:
        return _EmptyStateConfig(
          icon: Icons.rate_review_outlined,
          title: loc.noCommentsYet.split("\n")[0],
          subtitle: loc.noCommentsYet.split("\n")[1],
        );
      case EmptyStateType.noJoinedEvents:
        return _EmptyStateConfig(
          icon: Icons.event_busy,
          title: loc.noEventsJoined.split("\n")[0],
          subtitle: loc.noEventsJoined.split("\n")[1],
        );
      case EmptyStateType.noFollowers:
        return _EmptyStateConfig(
          icon: Icons.person_add_disabled,
          title: loc.noFollowersYet.split("\n")[0],
          subtitle: loc.noFollowersYet.split("\n")[1],
        );
      case EmptyStateType.noFollowing:
        return _EmptyStateConfig(
          icon: Icons.person_search,
          title: loc.notFollowingAnyone.split("\n")[0],
          subtitle: loc.notFollowingAnyone.split("\n")[1],
        );
      case EmptyStateType.noMessages:
        return _EmptyStateConfig(
          icon: Icons.question_answer_outlined,
          title: loc.noMessages.split("\n")[0],
          subtitle: loc.noMessages.split("\n")[1],
        );
      case EmptyStateType.noEvents:
        return _EmptyStateConfig(
          icon: Icons.diversity_3,
          title: loc.noActivitiesYet.split("\n")[0],
          subtitle: loc.noActivitiesYet.split("\n")[1],
        );
      case EmptyStateType.noCowork:
        return _EmptyStateConfig(
          icon: Icons.groups,
          title: loc.noCoworkYet.split("\n")[0],
          subtitle: loc.noCoworkYet.split("\n")[1],
        );
      case EmptyStateType.noCollab:
        return _EmptyStateConfig(
          icon: Icons.people_alt,
          title: loc.noCollaborationsYet.split("\n")[0],
          subtitle: loc.noCollaborationsYet.split("\n")[1],
        );
      case EmptyStateType.noPlaceWithFeatures:
        return _EmptyStateConfig(
          icon: Icons.place_outlined,
          title: loc.noPlaceWithFeatures,
          subtitle: loc.tryOtherPlace,
        );
    }
  }
}

class _EmptyStateConfig {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
