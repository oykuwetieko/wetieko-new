import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_together_detail/together_gallery.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_together_detail/together_overview.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_together_detail/together_segment_switcher.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_together_detail/workplace_overview.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_tags.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_hours.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_together_detail/together_join_button.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/04_event_memories_screen.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';

enum DetailTab { work, location }

class DiscoverTogetherDetailScreen extends StatefulWidget {
  final EventModel event;

  const DiscoverTogetherDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<DiscoverTogetherDetailScreen> createState() =>
      _DiscoverTogetherDetailScreenState();
}

class _DiscoverTogetherDetailScreenState
    extends State<DiscoverTogetherDetailScreen> {
  DetailTab selectedTab = DetailTab.work;

bool get isEventCompleted {
  final e = widget.event;
  try {
    // 🔹 1. Tarihi otomatik çözümle (ISO 8601 desteği)
    DateTime? date = DateTime.tryParse(e.date);

    // 🔹 2. Eğer parse edemediyse, dd/MM/yyyy formatını dene
    if (date == null) {
      final dateParts = e.date.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        date = DateTime(year, month, day);
      }
    }

    if (date == null) {
      debugPrint('❌ Tarih çözümlenemedi: ${e.date}');
      return false;
    }

    // ⏰ endTime örnek: "14:05"
    final timeParts = e.endTime.split(':');
    if (timeParts.length != 2) {
      debugPrint('❌ Saat formatı hatalı: ${e.endTime}');
      return false;
    }

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // 🔹 UTC → local dönüştür
    final eventEndDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    final now = DateTime.now();


    return eventEndDateTime.isBefore(now);
  } catch (err) {
    debugPrint('⚠️ Hata: $err');
    return false;
  }
}




  String getSelectedTabLabel(DetailTab tab) {
    final loc = AppLocalizations.of(context)!;
    switch (tab) {
      case DetailTab.work:
        return loc.workDetail;
      case DetailTab.location:
        return loc.placeDetail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final event = widget.event;
    final place = event.place;
    final currentUser = context.watch<UserStateNotifier>().state.user;
    final isEventOwner = currentUser?.id == event.creator.id;
    final isJoined = event.participants.any((u) => u.id == currentUser?.id);

    final galleryImages = place.allImageUrls.isNotEmpty
        ? place.allImageUrls
        : ['assets/images/placeholder.jpg'];

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TogetherGallery(
                  galleryImages: galleryImages,
                  isNetworkImages: place.allImageUrls.isNotEmpty,
                ),
                TogetherOverview(event: event),
                TogetherSegmentSwitcher(
                  selectedTab: selectedTab.name,
                  onTabSelected: (tabText) {
                    setState(() {
                      selectedTab =
                          DetailTab.values.firstWhere((e) => e.name == tabText);
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedTab == DetailTab.work)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: AppColors.onboardingSubtitle,
                        height: 1.5,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WorkplaceOverview(place: place),
                        WorkplaceTags(
                          tags: [
                            ...place.workingConditionTags,
                            ...place.spaceFeatureTags,
                          ],
                          place: place,
                        ),
                        WorkplaceHours(weekdayText: place.weekdayText),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TogetherJoinButton(
                    isDisabled: isEventCompleted,
                    onTap: isEventCompleted
                        ? null
                        : isEventOwner
                            ? () {}
                            : () {
                                CustomAlert.show(
                                  context,
                                  title: isJoined
                                      ? loc.cancelParticipationTitle
                                      : loc.participationTitle,
                                  description: isJoined
                                      ? loc.cancelParticipationDescription
                                      : loc.participationDescription,
                                  icon: isJoined
                                      ? Icons.cancel_outlined
                                      : Icons.pending_actions,
                                  confirmText:
                                      isJoined ? loc.cancelJoin : loc.join,
                                  cancelText: loc.cancel2,
                                  onConfirm: () async {
                                    final notifier =
                                        context.read<EventStateNotifier>();
                                    try {
                                      if (isJoined) {
                                        await notifier.leaveEvent(event.id);
                                      } else {
                                        await notifier.joinEvent(event.id);
                                      }

                                      CustomAlert.show(
                                        context,
                                        title: isJoined
                                            ? loc.cancelEventTitle
                                            : loc.applicationReceivedTitle,
                                        description: isJoined
                                            ? loc.cancelEventDescription
                                            : loc.applicationReceivedDescription,
                                        icon: isJoined
                                            ? Icons.event_busy
                                            : Icons.event_available,
                                        confirmText: loc.ok,
                                        onConfirm: () {
                                          if (isJoined) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainNavigationWrapper(
                                                  initialIndex: 0,
                                                  initialDiscoverCategoryKey:
                                                      'collaborateNow',
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const EventMemoriesScreen(),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    } catch (_) {}
                                  },
                                  onCancel: () {},
                                );
                              },
                    buttonText: isEventCompleted
                        ? loc.eventCompleted // 🔴 “Event Completed”
                        : isEventOwner
                            ? loc.ownerEventButtonLabel
                            : isJoined
                                ? loc.cancelParticipation
                                : null,
                  ),
                ),
                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
