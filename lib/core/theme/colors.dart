import 'package:flutter/material.dart';

class AppColors {
  // Ana ve İkincil Renkler
  static const Color primary = Color(0xFF3A7BD5);      

  // Nötr Renkler
  static const Color neutralLight = Color(0xFFF5F7FA); 
  static const Color neutralDark = Color(0xFF2E3A59);  
  static const Color neutralGrey = Color(0xFFD9E1EC);  
  static const Color neutralText = Color(0xFF7B8AA0); 

  // Onboarding
  static const Color onboardingBackground = neutralLight;
  static const Color onboardingTitle = neutralDark;
  static const Color onboardingSubtitle = neutralText;
  static const Color onboardingButtonBackground = primary;
  static const Color onboardingButtonText = Colors.white;
  static const Color onboardingButtonBorder = Color(0x804A90E2); 

  // Privacy
  static const Color privacyText = neutralText;

  // Close (X)
  static const Color closeButtonBackground = Color(0xFFE1F0FF); 
  static const Color closeButtonIcon = Color(0xFF3A7BD5);      

  // TextField
  static const Color textFieldBorder = neutralGrey;
  static const Color textFieldText = neutralDark;

  // Navigasyon Butonları
  static const Color nextButton = Color(0xFF3A7BD5);  
  static const Color backButton = Color(0xFF3A7BD5);  

  // Step Bar
  static const Color stepBar = Color(0xFF9EC9F5);      

  static const Color categoryActive = Color(0xFF3A7BD5); 
  static const Color categoryInactiveBackground = Color(0xFFF2F6FC); 
  static const Color categoryInactiveText = Color(0xFF6A88B1);       

  // 🔹 Etiketler / Puanlar
  static const Color tagBackground = Color(0xFFE7F0FB);   
  static const Color tagText = Color(0xFF3A7BD5);         
  static const Color ratingStar = Color(0xFFE4B343);      

  static const Color fabBackground = Color(0xFF2C3E5D); 
  static const Color fabIcon = Colors.white;            

  // 🔻 Bottom Navigation Bar
  static const Color bottomNavBackground = Color(0xFF1F2A40);
  static const Color bottomNavActive = Colors.white;
  static const Color bottomNavInactive = Color(0xFF8DA3C2);
 // Açık versiyon

  // ✔ Kartlar ve detay arka planları
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x11000000);

  static const Color overlayBackground = Color(0xFFFFFFFF);

  // 🔴 Çıkış Yap butonu
  static const Color logoutButtonBackground = Color(0xFFFF8A80);
}
