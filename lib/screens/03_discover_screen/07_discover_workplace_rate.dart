import 'package:flutter/material.dart';
import 'package:Wetieko/models/place_model.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_rate.dart';
import 'package:Wetieko/widgets/discover/discover_detail/discover_workplace_detail/workplace_features_selector.dart';
import 'package:Wetieko/screens/03_discover_screen/08_discover_workplace_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverWorkplaceRateScreen extends StatefulWidget {
  final Place place;

  const DiscoverWorkplaceRateScreen({
    super.key,
    required this.place,
  });

  @override
  State<DiscoverWorkplaceRateScreen> createState() => _DiscoverWorkplaceRateScreenState();
}

class _DiscoverWorkplaceRateScreenState extends State<DiscoverWorkplaceRateScreen> {
  Map<String, int> _ratings = {};
  Map<String, bool> _features = {};

  void _handleRatingChanged(Map<String, int> ratings) {
    setState(() {
      _ratings = ratings;
    });
  }

  void _handleFeaturesChanged(Map<String, bool> features) {
    setState(() {
      _features = features;
    });
  }

  void _goToReviewScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiscoverWorkplaceReviewScreen(
          place: widget.place,
          ratings: _ratings,
          features: _features,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: '${widget.place.name} ${loc.rate}',
        showStepBar: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              WorkplaceRate(
                onRatingChanged: _handleRatingChanged,
              ),
              const SizedBox(height: 20),
              WorkplaceFeaturesSelector(
                onFeaturesChanged: _handleFeaturesChanged,
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: loc.addPhotoAndComment,
                icon: Icons.upload_file,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                onPressed: _goToReviewScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
