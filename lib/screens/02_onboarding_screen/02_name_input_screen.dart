import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Wetieko/widgets/onboarding/close_button.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/common/custom_text_field.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';

import 'package:Wetieko/screens/02_onboarding_screen/03_birthdate_input_screen.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Wetieko/core/theme/colors.dart';

class NameInputScreen extends StatefulWidget {
  final bool fromProfileEdit;

  const NameInputScreen({super.key, this.fromProfileEdit = false});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _handleNext() {
    final name = _nameController.text.trim();
    if (name.length >= 3) {
      context.read<UserStateNotifier>().setFullName(name);

      if (widget.fromProfileEdit) {
        Navigator.pop(context); 
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BirthdateInputScreen(),
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.minNameLength;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: NextButton(onPressed: _handleNext),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                      title: loc.fullNameLabel,
                      subtitle: widget.fromProfileEdit
                          ? loc.fullNameInfo
                          : loc.fullNameInfo,
                      align: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: '',
                      uppercase: true,
                      controller: _nameController,
                      focusNode: _focusNode,
                      onChanged: (value) {
                        if (value.trim().length >= 3 && _errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.fabBackground, fontSize: 14),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 40,
              right: 3,
              child: CloseButtonWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
