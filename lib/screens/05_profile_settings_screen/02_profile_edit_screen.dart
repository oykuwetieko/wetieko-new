import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 🌍 Çeviri desteği
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/profile_settings/editable_profile_info_list.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.editProfile, 
        showStepBar: false,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.zero, // 🔹 Boşluk bırakma
        child: EditableProfileInfoList(),
      ),
    );
  }
}
