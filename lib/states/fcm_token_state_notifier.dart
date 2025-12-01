import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Wetieko/data/repositories/fcm_token_repository.dart';
import 'package:Wetieko/models/fcm_token.dart';

class FcmTokenStateNotifier extends ChangeNotifier {
  final FcmTokenRepository repo;
  FcmTokenStateNotifier(this.repo);

  List<FcmToken> _tokens = [];
  List<FcmToken> get tokens => _tokens;

  String? currentToken;

  Future<void> initFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);

      currentToken = await messaging.getToken();
      final deviceType = Platform.isIOS ? 'ios' : 'android';

     

      if (currentToken != null) {
      
        await repo.createOrUpdateToken(currentToken!); // ✅ sadece token gönderiyoruz
       

        _tokens = await repo.getTokens();
        
        for (final t in _tokens) {
          print('   → ${t.token} (${t.deviceType})');
        }

        notifyListeners();
      } else {
       
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      
        if (currentToken != null) {
          await repo.updateToken(currentToken!, newToken);
        
        }
        currentToken = newToken;
        notifyListeners();
      });
    } catch (e) {
    
    }
  }
/*
  Future<void> deleteToken() async {
    if (currentToken == null) return;
    print('🗑️ [FCM] Token backend’den siliniyor: $currentToken');
    await repo.deleteToken(currentToken!);
    _tokens.removeWhere((t) => t.token == currentToken);
    notifyListeners();
  } */
}
