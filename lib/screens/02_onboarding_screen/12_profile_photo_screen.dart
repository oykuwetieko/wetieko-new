import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/widgets/common/app_bar.dart';
import 'package:Wetieko/widgets/onboarding/heading_text.dart';
import 'package:Wetieko/widgets/common/photo_picker_sheet.dart';
import 'package:Wetieko/widgets/onboarding/next_button.dart';
import 'package:Wetieko/managers/photo_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Wetieko/navigation/main_navigation_wrapper.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final PhotoManager _photoManager = PhotoManager();
  File? _selectedPhoto;
  bool _isLoading = false;

  Future<void> _handlePhotoSelection(File photo) async {
    final userNotifier = context.read<UserStateNotifier>();
    setState(() => _isLoading = true);

    final token = await TokenStorageService().getToken();
    if (token == null || token.isEmpty) {
      // Token yok → local hafızaya kaydet
      final dir = await getApplicationDocumentsDirectory();
      final localPath = '${dir.path}/temp_profile.jpg';
      await photo.copy(localPath);
      _selectedPhoto = File(localPath);
      userNotifier.setProfileImage(localPath);
    } else {
      // Token var → backend'e yükle
      await userNotifier.updateProfileImage(photo);
      _selectedPhoto = photo;
    }

    setState(() => _isLoading = false);
  }

  void _showPhotoPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PhotoPickerSheet(
          onPickGallery: () async {
            Navigator.pop(context);
            final photo = await _photoManager.pickFromGallery();
            if (photo != null) {
              await _handlePhotoSelection(photo);
            }
          },
          onPickCamera: () async {
            Navigator.pop(context);
            final photo = await _photoManager.pickFromCamera();
            if (photo != null) {
              await _handlePhotoSelection(photo);
            }
          },
          onDelete: () async {
            Navigator.pop(context);
            setState(() => _isLoading = true);
            final token = await TokenStorageService().getToken();
            final userNotifier = context.read<UserStateNotifier>();

            if (token != null && token.isNotEmpty) {
              await userNotifier.updateProfileImage(null);
            }
            _selectedPhoto = null;
            userNotifier.setProfileImage('');
            setState(() => _isLoading = false);
          },
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  /// Next butonuna basıldığında çağrılır.
  /// Eğer lokal geçici fotoğraf varsa silinir.
  Future<void> _goToMainScreen() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final localPath = '${dir.path}/temp_profile.jpg';
      final localFile = File(localPath);

      if (await localFile.exists()) {
        await localFile.delete();
        debugPrint('Temp profile photo deleted: $localPath');
      }
    } catch (e) {
      debugPrint('Error deleting local photo: $e');
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationWrapper(initialIndex: 0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final profileImagePathOrUrl =
        context.watch<UserStateNotifier>().state.profileImage;

    final imageWidget = () {
      if (_selectedPhoto != null) {
        return DecorationImage(image: FileImage(_selectedPhoto!), fit: BoxFit.cover);
      }
      if (profileImagePathOrUrl != null && profileImagePathOrUrl.isNotEmpty) {
        if (profileImagePathOrUrl.startsWith('http')) {
          return DecorationImage(image: NetworkImage(profileImagePathOrUrl), fit: BoxFit.cover);
        } else {
          return DecorationImage(image: FileImage(File(profileImagePathOrUrl)), fit: BoxFit.cover);
        }
      }
      return null;
    }();

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      appBar: const CustomAppBar(
        totalSteps: 10,
        currentStep: 10,
        showStepBar: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: NextButton(
          onPressed: _goToMainScreen,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(
                  title: localizations.addProfilePhoto,
                  subtitle: localizations.photoInfo,
                  align: TextAlign.left,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showPhotoPickerSheet,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.onboardingBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      image: imageWidget,
                    ),
                    child: imageWidget == null
                        ? const Center(
                            child: Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          )
                        : null,
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
