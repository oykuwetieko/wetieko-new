import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:Wetieko/states/user_state_notifier.dart';
import 'package:Wetieko/models/update_user_dto.dart';

class LanguageManager extends ChangeNotifier {
  static const String _languageCodeKey = 'languageCode';
  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];

  Locale _locale = const Locale('tr');
  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_languageCodeKey);
    _locale = (savedCode != null && _isSupported(Locale(savedCode)))
        ? Locale(savedCode)
        : const Locale('tr');
    notifyListeners();
  }

  /// ✅ API başarılıysa `true`, hata olursa `false` döner
  Future<bool> setLocale(String languageCode, {BuildContext? context}) async {
    if (!_isSupported(Locale(languageCode))) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);

    _locale = Locale(languageCode);
    notifyListeners();

    if (context != null) {
      try {
        final userNotifier = Provider.of<UserStateNotifier>(context, listen: false);
        final currentUser = userNotifier.user;

        if (currentUser != null && currentUser.id.isNotEmpty) {
          await userNotifier.userRepo.updateMe(UpdateUserDto(language: languageCode));
          userNotifier.setLanguage(languageCode);
          return true; // ✅ Başarılı
        }
      } catch (e) {
        debugPrint("⚠️ Dil backend'e kaydedilemedi: $e");
        return false;
      }
    }
    return true; // sadece local güncelleme varsa başarılı say
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }
}
