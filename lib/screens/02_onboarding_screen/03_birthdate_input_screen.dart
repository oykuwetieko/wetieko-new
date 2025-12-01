import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/onboarding/birthdate_picker.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/screens/02_onboarding_screen/04_gender_selection_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/theme/colors.dart';

class BirthdateInputScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const BirthdateInputScreen({super.key, this.fromProfileEdit = false});

  @override
  State<BirthdateInputScreen> createState() => _BirthdateInputScreenState();
}

class _BirthdateInputScreenState extends State<BirthdateInputScreen> {
  DateTime selectedDate = DateTime(2000, 12, 20);

  void _handleNext() {
    context.read<UserStateNotifier>().setBirthDate(selectedDate);

    if (widget.fromProfileEdit) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GenderSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,

      appBar: widget.fromProfileEdit
          ? AppBar(
              backgroundColor: AppColors.onboardingBackground,
              elevation: 0,
              automaticallyImplyLeading: false, // ✅ Geri butonu artık gelmez
            )
          : const CustomAppBar(showStepBar: false),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(onPressed: _handleNext),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(
              title: loc.birthDateLabel,
              subtitle: loc.birthDateInfo,
              align: TextAlign.left,
            ),
            BirthdatePicker(
              initialDate: selectedDate,
              onDateChanged: (dateString) {
                setState(() {
                  selectedDate = DateTime.parse(dateString);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
