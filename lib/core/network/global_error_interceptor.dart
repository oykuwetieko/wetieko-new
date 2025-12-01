import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/main.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';

class GlobalErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final context = navigatorKey.currentContext;

    if (context != null) {
      final loc = AppLocalizations.of(context)!;
      final overlayState = Navigator.of(context, rootNavigator: true).overlay;

      if (overlayState != null) {
        late final OverlayEntry entry;

        // 🧠 Hata mesajını alalım
        final message = err.response?.data.toString() ?? err.message ?? '';

        // 🔒 Silme engeli
        if (message.contains('silinemez')) {
          entry = OverlayEntry(
            builder: (_) => CustomAlert(
              title: loc.eventDeleteTimeLockTitle,
              description: loc.eventDeleteTimeLockDescription,
              icon: Icons.lock_clock_rounded,
              confirmText: loc.ok,
              onConfirm: () => entry.remove(),
            ),
          );
        }
        // ✏️ Tarih/saat/mekan değiştirilemez hatası
        else if (message.contains('tarih, saat veya mekan değiştirilemez')) {
          entry = OverlayEntry(
            builder: (_) => CustomAlert(
              title: loc.eventEditTimeLockTitle,
              description: loc.eventEditTimeLockDescription,
              icon: Icons.lock_clock_rounded,
              confirmText: loc.ok,
              onConfirm: () => entry.remove(),
            ),
          );
        }
        // 🚨 Diğer tüm hatalar
        else {
          entry = OverlayEntry(
            builder: (_) => CustomAlert(
              title: loc.unexpectedError,
              description: loc.unexpectedErrorMessage,
              icon: Icons.error_outline_rounded,
              confirmText: loc.ok,
              onConfirm: () => entry.remove(),
            ),
          );
        }

        overlayState.insert(entry);
      }
    }

    handler.next(err);
  }
}
