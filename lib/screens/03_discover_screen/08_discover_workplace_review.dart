import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart'; 
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/managers/photo_manager.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_photo_add.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_textfield.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate_info_card.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/data/sources/feedback_remote_data_source.dart';
import 'package:Wetieko/data/repositories/feedback_repository.dart';
import 'package:Wetieko/models/feedback_model.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/states/place_state_notifier.dart';

class DiscoverWorkplaceReviewScreen extends StatefulWidget {
  final Place place;
  final Map<String, int> ratings;
  final Map<String, bool> features;

  const DiscoverWorkplaceReviewScreen({
    super.key,
    required this.place,
    required this.ratings,
    required this.features,
  });

  @override
  State<DiscoverWorkplaceReviewScreen> createState() =>
      _DiscoverWorkplaceReviewScreenState();
}

class _DiscoverWorkplaceReviewScreenState
    extends State<DiscoverWorkplaceReviewScreen> {
  final PhotoManager _photoManager = PhotoManager();
  File? _selectedPhoto;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final FeedbackRepository _repository = FeedbackRepository(
    FeedbackRemoteDataSource(ApiService()),
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _handlePhotoChanged(File? photo) {
    setState(() => _selectedPhoto = photo);
  }

  Future<void> _handleSubmit() async {
    final comment = _commentController.text.trim();
    final loc = AppLocalizations.of(context)!;

    if (comment.isEmpty && _selectedPhoto == null) {
      CustomAlert.show(
        context,
        title: loc.feedbackMissingTitle,
        description: loc.feedbackMissingDescription,
        icon: Icons.error_outline_rounded,
        confirmText: loc.ok,
        onConfirm: () {},
      );
      return;
    }

    try {
      String? photoUrl;

      // 📌 Fotoğraf seçildiyse önce Cloudflare'a yükle
      if (_selectedPhoto != null) {
        photoUrl = await _repository.uploadFeedbackPhoto(_selectedPhoto!);
      }

      final dto = FeedbackDto(
      placeDbId: int.parse(widget.place.id),

        comment: comment.isNotEmpty ? comment : null,
        wifiScore: widget.ratings['wifi']?.toDouble(),
        socketScore: widget.ratings['socket']?.toDouble(),
        noiseScore: widget.ratings['silence']?.toDouble(),
        deskScore: widget.ratings['workDesk']?.toDouble(),
        ventilationScore: widget.ratings['ventilation']?.toDouble(),
        lightingScore: widget.ratings['lighting']?.toDouble(),
        meetingFriendly: widget.features['Toplantıya Uygun'] == true,
        openArea: widget.features['Açık Alan / Teras'] == true,
        petFriendly: widget.features['Hayvan Dostu'] == true,
        hasParking: widget.features['Otopark'] == true,
        hasView: widget.features['Manzara'] == true,
        photoUrl: photoUrl,
      );

      await _repository.submitFeedback(dto);

      final placeNotifier = context.read<PlaceStateNotifier>();
      if (placeNotifier.lastFetchedCity != null) {
        await placeNotifier.loadPlaces(city: placeNotifier.lastFetchedCity!);
      }

      if (!mounted) return;

      // 📌 Önce ana ekrana git
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationWrapper(initialIndex: 0),
        ),
        (route) => false,
      );

      // 📌 Yeni sayfa çizildikten sonra alert göster
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomAlert.show(
          context,
          title: loc.thankYouForContribution,
          description: loc.contributionHelps,
          icon: Icons.reviews_rounded,
          confirmText: loc.ok,
          onConfirm: () {},
        );
      });
    } catch (e) {
      CustomAlert.show(
        context,
        title: loc.unexpectedError,
        description: loc.unexpectedErrorMessage,
        icon: Icons.error_outline_rounded,
        confirmText: loc.ok,
        onConfirm: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        appBar: CustomAppBar(
          title: '${widget.place.name} ${loc.rate}',
          showStepBar: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              children: [
                WorkplaceRateInfoCard(
                  message: loc.shareExperienceInfo,
                ),
                WorkplaceRatePhotoAdd(
                  photo: _selectedPhoto,
                  onPhotoChanged: _handlePhotoChanged,
                ),
                const SizedBox(height: 20),
                WorkplaceRateTextField(
                  controller: _commentController,
                  focusNode: _focusNode,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 46),
          child: CustomButton(
            text: loc.shareExperience,
            icon: Icons.send,
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            onPressed: () async {
              await _handleSubmit();
            },
          ),
        ),
      ),
    );
  }
}
