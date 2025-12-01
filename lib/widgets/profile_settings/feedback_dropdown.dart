import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/profile_settings/feedback_textfield.dart';
import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/support_model.dart';
import 'package:Wetieko/data/sources/support_remote_data_source.dart';
import 'package:Wetieko/data/repositories/support_repository.dart';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/main.dart';

class FeedbackDropDown extends StatefulWidget {
  final VoidCallback onClose;

  const FeedbackDropDown({
    super.key,
    required this.onClose,
  });

  @override
  State<FeedbackDropDown> createState() => _FeedbackDropDownState();
}

class _FeedbackDropDownState extends State<FeedbackDropDown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // ✅ KLAVYE BOŞLUĞU
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.onboardingBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: AppColors.closeButtonIcon),
                    ),
                    Text(
                      loc.feedbackImproveTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.onboardingTitle,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 15),

                // Text Field
                FeedbackTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                ),

                const SizedBox(height: 20),

                // Send Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                    text: loc.shareExperience,
                    icon: Icons.send,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    onPressed: () async {
                      final text = _controller.text.trim();

                      if (text.length < 5) {
                        CustomAlert.show(
                          context,
                          title: loc.feedbackMissingTitle,
                          description: loc.feedbackMinLengthError,
                          icon: Icons.error_outline_rounded,
                          confirmText: loc.ok,
                          onConfirm: () {},
                        );
                        return;
                      }

                      try {
                        final support = Support(message: text);

                        final repo = SupportRepository(
                          SupportRemoteDataSource(ApiService()),
                        );
                        await repo.sendSupport(support);

                        Navigator.pop(context);

                        Future.microtask(() {
                          final rootContext = navigatorKey.currentContext;
                          if (rootContext != null) {
                            CustomAlert.show(
                              rootContext,
                              title: loc.thankYouForContribution,
                              description: loc.contributionHelps,
                              icon: Icons.reviews_rounded,
                              confirmText: loc.ok,
                              onConfirm: () {},
                              forceRootOverlay: true,
                            );
                          }
                        });
                      } catch (e) {}
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
