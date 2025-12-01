import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/empty_state_widget.dart';
import 'package:Wetieko/widgets/discover/discover_card/workplace_review_card.dart';
import 'package:Wetieko/states/place_state_notifier.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/screens/03_discover_screen/03_discover_workplace_detail_screen.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/models/feedback_model.dart';

class MyPlaceReviewsScreen extends StatefulWidget {
  final String? externalUserId;

  const MyPlaceReviewsScreen({super.key, this.externalUserId});

  @override
  State<MyPlaceReviewsScreen> createState() => _MyPlaceReviewsScreenState();
}

class _MyPlaceReviewsScreenState extends State<MyPlaceReviewsScreen> {
  List<PlaceFeedback> externalFeedbacks = [];
  bool _isLoading = false;

  bool get isOwnProfileView {
    final myUserId = context.read<UserStateNotifier>().state.user!.id;
    return widget.externalUserId == null || widget.externalUserId == myUserId;
  }

  @override
  void initState() {
    super.initState();
    if (isOwnProfileView) {
      context.read<PlaceStateNotifier>().loadMyFeedbacks();
    } else {
      _loadExternalFeedbacks();
    }
  }

  Future<void> _loadExternalFeedbacks() async {
    setState(() => _isLoading = true);
    final placeState = context.read<PlaceStateNotifier>();
    externalFeedbacks =
        await placeState.loadFeedbacksByUser(widget.externalUserId!);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final placeState = context.watch<PlaceStateNotifier>();
    final user = context.read<UserStateNotifier>().state;

    final isLoading = isOwnProfileView ? placeState.isLoading : _isLoading;

    // ✅ Geri bildirim listesi
    final feedbackList =
        isOwnProfileView ? placeState.myFeedbacks : externalFeedbacks;

    // ✅ En yeni tarihten en eskiye göre sırala
    final sortedFeedbackList = [...feedbackList]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(title: loc.myVenueReviews),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedFeedbackList.isEmpty
              ? Center(
                  child: EmptyStateWidget(
                    type: isOwnProfileView
                        ? EmptyStateType.noReviews
                        : EmptyStateType.noData,
                  ),
                )
              : ListView.builder(
                  key: ValueKey(
                      'list_${widget.externalUserId ?? 'me'}_${sortedFeedbackList.length}'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: sortedFeedbackList.length,
                  itemBuilder: (context, index) {
                    final fb = sortedFeedbackList[index];
                    return GestureDetector(
                      onTap: () {
                        if (fb.place != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DiscoverWorkplaceDetailScreen(
                                place: fb.place!,
                              ),
                            ),
                          );
                        }
                      },
                      child: WorkplaceReviewCard(
                        key: ValueKey('fb_${fb.id}'),
                        userName: fb.placeName ?? '',
                        placeAddress: fb.placeAddress ?? '',
                        userTitle: '',
                        review: fb.comment ?? '',
                        imagePath:
                            fb.userProfileImage ?? user.profileImage ?? '',
                        reviewPhotoUrl: fb.photoUrl ?? '',
                        reviewDate: fb.createdAt,
                        ratings: {
                          'wifi': fb.wifi.round(),
                          'socket': fb.socket.round(),
                          'silence': fb.noiseLevel.round(),
                          'workDesk': fb.workDesk.round(),
                          'lighting': fb.lighting.round(),
                          'ventilation': fb.ventilation.round(),
                        },
                        showAvatar: false,
                        showDelete: isOwnProfileView,
                        onDelete: () {
                          CustomAlert.show(
                            context,
                            title: loc.deleteCommentConfirmationTitle,
                            description: loc.deleteCommentWarning,
                            icon: Icons.delete_forever_rounded,
                            confirmText: loc.deleteComment,
                            cancelText: loc.cancel,
                            isDestructive: true,
                            onConfirm: () async {
                              final overlay =
                                  Overlay.of(context, rootOverlay: true);
                              if (overlay == null) return;

                              final placeNotifier =
                                  context.read<PlaceStateNotifier>();

                              await placeNotifier.deleteFeedback(fb.id.toString());

                              if (!isOwnProfileView) {
                                await _loadExternalFeedbacks();
                              } else {
                                await context
                                    .read<PlaceStateNotifier>()
                                    .loadMyFeedbacks();
                              }

                              if (!mounted) return;

                              late final OverlayEntry entry;
                              entry = OverlayEntry(
                                builder: (_) => CustomAlert(
                                  title: loc.commentDeletedTitle,
                                  description: loc.commentDeletedMessage,
                                  icon: Icons.check_circle_rounded,
                                  confirmText: loc.ok,
                                  onConfirm: () {
                                    entry.remove();
                                  },
                                ),
                              );
                              overlay.insert(entry);
                            },
                            onCancel: () {},
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
