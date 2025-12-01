
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/models/feedback_model.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_gallery.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_overview.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_tags.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_segment_switcher.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_hours.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_button.dart';
import 'package:Wetieko/screens/03_discover_screen/07_discover_workplace_rate.dart';
import 'package:Wetieko/widgets/discover/discover_card/workplace_review_card.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/data/sources/feedback_remote_data_source.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_checkin_card.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

enum WorkplaceTab { detail, comments }

class DiscoverWorkplaceDetailScreen extends StatefulWidget {
  final Place place;

  const DiscoverWorkplaceDetailScreen({super.key, required this.place});

  @override
  State<DiscoverWorkplaceDetailScreen> createState() =>
      _DiscoverWorkplaceDetailScreenState();
}

class _DiscoverWorkplaceDetailScreenState
    extends State<DiscoverWorkplaceDetailScreen> {
  WorkplaceTab selectedTab = WorkplaceTab.detail;
  List<PlaceFeedback> feedbacks = [];
  bool isLoading = true;

  String get selectedTabKey => selectedTab.name;

  WorkplaceTab getTabFromKey(String key) {
    return key == 'comments' ? WorkplaceTab.comments : WorkplaceTab.detail;
  }

  @override
  void initState() {
    super.initState();

    final placeNotifier =
        Provider.of<PlaceStateNotifier>(context, listen: false);
    final user =
        Provider.of<UserStateNotifier>(context, listen: false).state.user;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await placeNotifier.loadCheckInsByPlace(widget.place.id);
      if (user != null) {
        await placeNotifier.loadMyCheckIns(user.id);
      }
      await _fetchFeedbacks();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchFeedbacks() async {
    try {
      final response = await FeedbackRemoteDataSource(ApiService())
          .getFeedbacksByPlace(widget.place.id);
      feedbacks = response;
    } catch (e) {
      feedbacks = [];
    }
  }

  void _showFavoriteAlert(BuildContext context, bool isAdded) {
    final loc = AppLocalizations.of(context)!;

    CustomAlert.show(
      context,
      title: isAdded ? loc.favoriteAddedTitle : loc.favoriteRemovedTitle,
      description:
          '${widget.place.name} ${isAdded ? loc.favoriteAddedMessage : loc.favoriteRemovedMessage}',
      icon: Icons.check_circle_rounded,
      confirmText: loc.ok,
      onConfirm: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeNotifier = context.watch<PlaceStateNotifier>();
    final user = context.watch<UserStateNotifier>().state.user;

    final isDisabled = placeNotifier.isDisabledForPlace(widget.place.id);

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        top: false,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WorkplaceGallery(
                      place: widget.place,
                      onFavoriteToggled: (isAdded) =>
                          _showFavoriteAlert(context, isAdded),
                    ),
                    WorkplaceOverview(place: widget.place),
                    WorkplaceCheckinCard(
                      attendees: placeNotifier.placeAttendees,
                      isDisabled: isDisabled,
                      onSelect: () async {
                        if (user != null && !isDisabled) {
                          await placeNotifier.addCheckIn(widget.place.id);
                          await placeNotifier.loadCheckInsByPlace(widget.place.id);
                          await placeNotifier.loadMyCheckIns(user.id);
                        }
                      },
                    ),
                    WorkplaceSegmentSwitcher(
                      selectedTab: selectedTabKey,
                      onTabSelected: (key) {
                        setState(() {
                          selectedTab = getTabFromKey(key);
                        });
                      },
                      commentCount: feedbacks.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedTab == WorkplaceTab.detail) ...[
                            const SizedBox(height: 30),
                            WorkplaceTags(
                              tags: widget.place.workingConditionTags,
                              place: widget.place,
                            ),
                            const SizedBox(height: 2),
                            WorkplaceHours(
                              weekdayText: widget.place.weekdayText,
                            ),
                            const SizedBox(height: 24),
                            WorkplaceRateButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DiscoverWorkplaceRateScreen(
                                      place: widget.place,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ] else if (selectedTab == WorkplaceTab.comments) ...[
                            const SizedBox(height: 12),
                            if (feedbacks.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2, bottom: 4),
                                child: EmptyStateWidget(
                                  type: EmptyStateType.noReviewsWorkplaceDetail,
                                  place: widget.place,
                                ),
                              )
                            else
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: feedbacks.length,
                                itemBuilder: (context, index) {
                                  final feedback = feedbacks[index];
                                  return WorkplaceReviewCard(
                                    userName: feedback.user?.name ?? 'Bilinmeyen',
                                    placeAddress: feedback.placeAddress,
                                    userTitle: feedback.user?.careerPosition.isNotEmpty == true
                                        ? feedback.user!.careerPosition.first
                                        : '',
                                    review: feedback.comment ?? '',
                                    imagePath: feedback.user?.profileImage ?? '',
                                    reviewPhotoUrl: feedback.photoUrl ?? '',
                                    reviewDate: feedback.createdAt,
                                    ratings: {
                                      'wifi': feedback.wifi.toInt(),
                                      'socket': feedback.socket.toInt(),
                                      'silence': feedback.noiseLevel.toInt(),
                                      'workDesk': feedback.workDesk.toInt(),
                                      'lighting': feedback.lighting.toInt(),
                                      'ventilation': feedback.ventilation.toInt(),
                                    },
                                    user: feedback.user, // ✅ profile geçiş için
                                  );
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
