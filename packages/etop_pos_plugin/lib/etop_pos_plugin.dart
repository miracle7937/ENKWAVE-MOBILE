import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Stub implementation for local/emulator builds.
/// For production on Horizon Pay S60 hardware, use the real plugin from:
/// git@github.com:miracle7937/e-top-horizon-plugin.git
class EtopPosPlugin {
  factory EtopPosPlugin() => _instance;
  EtopPosPlugin._();

  static final EtopPosPlugin _instance = EtopPosPlugin._();

  Future<void> ePayment({
    required BuildContext context,
    Map<String, dynamic>? terminalInfo,
    String? userID,
  }) async {
    debugPrint(
      'EtopPosPlugin.ePayment stub — install e-top-horizon-plugin for real POS.',
    );
  }

  Future<void> balanceInquiry(Map<String, dynamic> json) async {
    debugPrint('EtopPosPlugin.balanceInquiry stub: $json');
  }

  Future<void> openEOD({
    required BuildContext context,
    required String userID,
    required String baseRoute,
  }) async {
    debugPrint('EtopPosPlugin.openEOD stub — userID=$userID baseRoute=$baseRoute');
  }

  Future<void> prepDevice(String terminalNo, Map<String, dynamic> config) async {
    debugPrint('EtopPosPlugin.prepDevice stub — terminal=$terminalNo');
  }

  Future<void> reprint({required Map<dynamic, dynamic> map}) async {
    debugPrint('EtopPosPlugin.reprint stub: $map');
  }
}
