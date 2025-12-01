import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/models/event_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/activity_gallery.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/activity_description.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/event_tags.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/activity_join_button.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/activity_segment_switcher.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/activity_overview.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_activity_detail/workplace_overview.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_tags.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_hours.dart';
import 'package:Wetieko/states/event_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/04_event_memories_screen.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/core/extensions/place_image_extension.dart';

class DiscoverActivityDetailScreen extends StatefulWidget {
  final EventModel event;

  const DiscoverActivityDetailScreen({super.key, required this.event});

  @override
  State<DiscoverActivityDetailScreen> createState() =>
      _DiscoverActivityDetailScreenState();
}

class _DiscoverActivityDetailScreenState
    extends State<DiscoverActivityDetailScreen> {
  late String selectedTab;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;
    selectedTab = loc.eventDetail;
  }

  /// ✅ Etkinlik geçmiş mi kontrolü
  bool get isEventCompleted {
    final e = widget.event;
    try {
      // 🔹 ISO format desteği (örnek: 2025-10-28T00:00:00.000Z)
      DateTime? date = DateTime.tryParse(e.date);

      // 🔹 Eğer parse edemediyse, dd/MM/yyyy formatını dene
      if (date == null) {
        final parts = e.date.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          date = DateTime(year, month, day);
        }
      }

      if (date == null) {
        debugPrint('❌ Tarih çözümlenemedi: ${e.date}');
        return false;
      }

      // ⏰ Saat formatı: "14:05"
      final timeParts = e.endTime.split(':');
      if (timeParts.length != 2) {
        debugPrint('❌ Saat formatı hatalı: ${e.endTime}');
        return false;
      }

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // 🔹 Etkinlik bitiş zamanı
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final event = widget.event;
    final place = event.place;
    final currentUser = context.watch<UserStateNotifier>().state.user;
    final isEventOwner = currentUser?.id == event.creator.id;
    final isJoined = event.participants.any((u) => u.id == currentUser?.id);

    final remainingSeats = (event.maxParticipants ?? 0) -
        event.participants.where((p) => p.id != event.creator.id).length;

    final galleryImages = place.allImageUrls.isNotEmpty
        ? place.allImageUrls
        : ['assets/images/placeholder.jpg'];
    final isNetworkImages = place.allImageUrls.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📸 Galeri
                ActivityGallery(
                  galleryImages: galleryImages,
                  isNetworkImages: isNetworkImages,
                ),

                /// 🧠 Özet
                ActivityOverview(event: event),

                /// 🪄 Sekme seçici
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ActivitySegmentSwitcher(
                    selectedTab: selectedTab,
                    onTabSelected: (value) {
                      setState(() {
                        selectedTab = value;
                      });
                    },
                  ),
                ),

                /// 📋 Açıklama veya Mekan Detayı
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Builder(
                    builder: (_) {
                      if (selectedTab == loc.placeDetail) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WorkplaceOverview(event: event),
                            const SizedBox(height: 20),
                            WorkplaceTags(
                              tags: [
                                ...place.workingConditionTags,
                                ...place.spaceFeatureTags,
                              ],
                              place: place,
                            ),
                            WorkplaceHours(weekdayText: place.weekdayText),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ActivityDescription(description: event.description),
                            const SizedBox(height: 24),
                            if (event.tags.isNotEmpty)
                              EventTagsWidget(tags: event.tags),
                          ],
                        );
                      }
                    },
                  ),
                ),

                const Spacer(),

                /// 🙋 Katılım butonu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActivityJoinButton(
                    remainingSeats: remainingSeats,
                    isDisabled: isEventCompleted, // ✅ EKLENDİ
                    buttonLabel: isEventCompleted
                        ? loc.eventCompleted // ✅ Geçmiş etkinlik
                        : isEventOwner
                            ? loc.ownerEventButtonLabel
                            : isJoined
                                ? loc.cancelParticipation
                                : null,
                    onJoin: isEventCompleted
                        ? null // ✅ Tıklama kapalı
                        : isEventOwner
                            ? () {}
                            : () {
                                /// ✅ Katılım onayı uyarısı
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
                                            String categoryKey = 'activities';
                                            if (event.type ==
                                                EventType.COWORK) {
                                              categoryKey = 'cowork';
                                            }
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MainNavigationWrapper(
                                                  initialIndex: 0,
                                                  initialDiscoverCategoryKey:
                                                      categoryKey,
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
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
