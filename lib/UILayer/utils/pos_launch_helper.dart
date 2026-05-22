import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/services/session_sync_service.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/utils/pos_prep_progress_overlay.dart';
import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Validates terminal assignment + TID config from login / user-info before POS.
class PosLaunchHelper {
  /// POS plugin (Retrofit) needs a trailing slash; stale TMS URLs often point at test.enkpay.com.
  static String normalizePosApiBaseUrl(String? raw) {
    var url = (raw ?? '').trim();
    if (url.isEmpty ||
        url.contains('test.enkpay.com') ||
        url.contains('test2.enkpay.com')) {
      url = AppRoute.baseRoute;
    }
    url = url.replaceAll(RegExp(r'/+$'), '');
    if (!url.endsWith('/api')) {
      url = '$url/api';
    }
    if (!url.endsWith('/')) {
      url = '$url/';
    }
    return url;
  }

  static void _applyPosBaseUrl(TerminalConfig config) {
    config.baseUrl = normalizePosApiBaseUrl(config.baseUrl);
  }
  /// Latest `terminal_info` + `tid_config` from GET /user-info (same as login).
  static Future<({UserData user, TerminalConfig config})?> _loadSession(
    BuildContext context,
  ) async {
    UserData? user;
    TerminalConfig? config;

    try {
      user = await SessionSyncService.refreshAndPersist();
      config = await LocalDataStorage.getTerminalConfig();
    } catch (_) {
      user = await LocalDataStorage.getUserData();
      config = await LocalDataStorage.getTerminalConfig();
    }

    if (user == null) {
      snackBar(context, message: 'Please sign in again', forError: true);
      return null;
    }

    if (user.terminalInfo == null ||
        (user.terminalInfo?.terminalNo ?? '').isEmpty) {
      snackBar(
        context,
        message:
            'No POS terminal on your account. Assign a terminal in TMS, then sign out and sign in again.',
        forError: true,
      );
      return null;
    }

    if (config == null || config.hasNull) {
      snackBar(
        context,
        message:
            'POS keys are missing on the server for your account. Set TID config in TMS, then sign in again.',
        forError: true,
      );
      return null;
    }

    _applyPosBaseUrl(config);
    return (user: user, config: config);
  }

  static Future<({UserData user, TerminalConfig config})?> prepare(
    BuildContext context, {
    bool prepDevice = true,
    bool showLoader = false,
  }) async {
    final session = await _loadSession(context);
    if (session == null) return null;

    if (prepDevice) {
      // Flutter top bar handles progress; hide native "Downloading keys…" dialog.
      session.config.setShowLoader('false');
      try {
        await PosPrepProgressOverlay.run(context, task: () async {
          await EtopPosPlugin().prepDevice(
            session.user.terminalInfo!.terminalNo!,
            session.config.toJson(),
          );
        });
      } on PlatformException catch (e) {
        if (context.mounted) {
          snackBar(
            context,
            message: e.message ??
                'POS terminal prep failed. Check network and TID host settings.',
            forError: true,
          );
        }
        return null;
      }
    }

    return session;
  }
}
