import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:Wetieko/widgets/common/custom_button.dart';
import 'package:Wetieko/widgets/onboarding/terms_text.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/core/services/apple_sign_in_service.dart';
import 'package:Wetieko/core/services/google_sign_in_service.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/models/login_request_dto.dart';
import 'package:Wetieko/screens/02_onboarding_screen/13_notification_permission_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // ========================================================================
  //                          LOGIN HANDLE
  // ========================================================================

  Future<void> _handleLogin({
    required BuildContext context,
    required String provider,
    required String token,
  }) async {
    print("\n\n===============================================================");
    print("🔐 [_handleLogin] LOGIN BAŞLADI | Provider: $provider");
    print("===============================================================");
    print("🔐 BACKEND'E GİDECEK TOKEN:\n$token");
    print("===============================================================\n");

    final userNotifier = context.read<UserStateNotifier>();
    final state = userNotifier.state;

    final dto = LoginRequestDto(
      token: token,
      provider: provider,
      name: state.fullName ?? '',
      birthDate: state.birthDate,
      gender: state.gender ?? '',
      location: [state.city, state.district].whereType<String>().join(', '),
      usagePreference: state.usagePurposes,
      industry: state.sectors,
      careerPosition: state.positions,
      careerStage: state.experienceLevel ?? '',
      workEnvironment: state.workEnvironments,
      skills: state.skills,
      profileImage: null,
      language: ui.window.locale.languageCode,
    );

    print("📤 BACKEND'E GÖNDERİLEN DTO:");
    print(dto.toJson());
    print("---------------------------------------------------------------");

    try {
      final authRepo = userNotifier.authRepo;
      final userRepo = userNotifier.userRepo;

      // ======================================================
      //               BACKEND LOGIN REQUEST
      // ======================================================
      print("🌍 BACKEND LOGIN İSTEĞİ ATILIYOR...");
      final user = provider == 'google'
          ? await authRepo.loginWithGoogle(dto)
          : await authRepo.loginWithApple(dto);

      print("===============================================================");
      print("📥 BACKEND'DEN DÖNEN USERMODEL (HAM):");
      print(" - MODEL.accessToken: ${user.accessToken}");
      print(" - MODEL.refreshToken: ${user.refreshToken}");
      print(" - USER.id: ${user.user.id}");
      print(" - USER.email: ${user.user.email}");
      print("===============================================================\n");

      // ======================================================
      //                 TOKEN KAYDETME ÖNCESİ
      // ======================================================
      print("💾 [DEBUG] KAYDIM ÖNCESİ SHARED PREF İÇERİĞİ:");
      final storedAccess = await TokenStorageService().getAccessToken();
      final storedRefresh = await TokenStorageService().getRefreshToken();
      print(" - storedAccessToken: $storedAccess");
      print(" - storedRefreshToken: $storedRefresh");
      print("---------------------------------------------------------------");

      // ======================================================
      //                  TOKENLARI KAYDET
      // ======================================================
      print("💾 TOKEN STORAGE’A KAYDEDİYORUM...");
      await TokenStorageService().saveToken(
        user.accessToken,
        user.refreshToken,
      );

      print("💾 [DEBUG] KAYITTAN SONRA SHARED PREF:");
      final savedAccess = await TokenStorageService().getAccessToken();
      final savedRefresh = await TokenStorageService().getRefreshToken();
      print(" - savedAccessToken: $savedAccess");
      print(" - savedRefreshToken: $savedRefresh");
      print("===============================================================\n");

      // ======================================================
      //          PROFİL FOTO YÜKLE (Varsa)
      // ======================================================
      final dir = await getApplicationDocumentsDirectory();
      final localPhoto = File('${dir.path}/temp_profile.jpg');
      if (await localPhoto.exists()) {
        print("📸 GEÇİCİ PROFİL FOTO BULUNDU → BACKEND'E YÜKLENECEK");
        await userNotifier.updateProfileImage(localPhoto);
        await localPhoto.delete();
      }

      // ======================================================
      //               GETME → TOKEN DOĞRU ÇALIŞIYOR MU?
      // ======================================================
  

      // ======================================================
      //               NAVİGASYON
      // ======================================================
      print("➡️ NOTIFICATION PERMISSION SCREEN’E GEÇİLİYOR...");
      print("===============================================================\n");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NotificationPermissionScreen()),
        (route) => false,
      );
    } catch (e, st) {
      print("\n❌ LOGIN HATASI:");
      print("HATA → $e");
      print("STACKTRACE → $st\n");
      print("===============================================================\n");
    }
  }

  // ========================================================================
  //                     APPLE LOGIN
  // ========================================================================

  void _handleAppleLogin(BuildContext context) async {
    print("\n🍎 [AppleLogin] Başlatılıyor...");
    final credential = await AppleSignInService.signInWithApple();
    final token = credential?.identityToken;

    print("🍎 APPLE IDENTITY TOKEN:");
    print(token ?? "NULL TOKEN !!!");

    if (token == null) return;

    context.read<UserStateNotifier>()
      ..setAuthProvider('apple')
      ..setAppleIdToken(token);

    await _handleLogin(context: context, provider: 'apple', token: token);
  }

  // ========================================================================
  //                     GOOGLE LOGIN
  // ========================================================================

  void _handleGoogleLogin(BuildContext context) async {
    print("\n🟦 [GoogleLogin] Başlatılıyor...");
    final account = await GoogleSignInService.signInWithGoogle();

    if (account == null) {
      print("🟦 [GoogleLogin] CANCELLED");
      return;
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    print("🟦 GOOGLE ID TOKEN:");
    print(idToken ?? "NULL TOKEN !!!");

    if (idToken == null) return;

    context.read<UserStateNotifier>()
      ..setAuthProvider('google')
      ..setGoogleIdToken(idToken);

    await _handleLogin(context: context, provider: 'google', token: idToken);
  }

  // ========================================================================
  //                    UI
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.25;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/wetieko_logo.png',
                        width: logoSize,
                        height: logoSize,
                      ),
                      const SizedBox(height: 48),
                      Text(
                        loc.headingTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.fabBackground,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loc.headingSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onboardingSubtitle,
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: loc.continueWithGoogle,
                iconAssetPath: 'assets/images/google_logo.png',
                iconSize: 28,
                backgroundColor: AppColors.primary,
                textColor: AppColors.onboardingButtonText,
                onPressed: () => _handleGoogleLogin(context),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: loc.continueWithApple,
                icon: Icons.apple,
                iconSize: 28,
                hasBorder: true,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                borderColor: AppColors.onboardingButtonBorder,
                onPressed: () => _handleAppleLogin(context),
              ),
              const SizedBox(height: 20),
              const TermsText(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
