import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;
  ConnectionService._internal();

  StreamSubscription<InternetStatus>? _subscription;
  bool _isShowing = false;
  OverlayEntry? _alertEntry; // 🔹 açık alerti tutuyoruz

  void init(GlobalKey<NavigatorState> navigatorKey) {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      final navContext = navigatorKey.currentState?.context;
      if (navContext == null) {
       
        return;
      }

      final l10n = AppLocalizations.of(navContext)!;

      if (status == InternetStatus.disconnected) {
        debugPrint("🚨 İnternet kesildi");
        if (!_isShowing) {
          _isShowing = true;

        
          _alertEntry = OverlayEntry(
            builder: (_) => CustomAlert(
              title: l10n.connectionError,
              description: l10n.connectionFailed,
              icon: Icons.wifi_off,
              confirmText: l10n.tryAgain,
              onConfirm: () {
                debugPrint("⚠️ İnternet yok, tekrar dene butonuna basıldı");
               
              },
              forceRootOverlay: true,
            ),
          );

          navigatorKey.currentState?.overlay?.insert(_alertEntry!);
        }
      } else {
        debugPrint("✅ İnternet geri geldi");
        if (_isShowing) {
          _alertEntry?.remove(); 
          _alertEntry = null;
        }
        _isShowing = false;
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _isShowing = false;
    _alertEntry?.remove();
    _alertEntry = null;
  }
}
