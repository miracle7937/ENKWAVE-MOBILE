import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceServiceInit {
  static AndroidDeviceInfo? androidInfo;
  static String? deviceModel;
  static const String telpoDevice = 'TPS900';

  static bool get isTelpoDevice =>
      Platform.isAndroid && deviceModel == telpoDevice;

  static Future<void> initialize() async {
    if (!Platform.isAndroid) {
      log('DeviceServiceInit: skipped on ${Platform.operatingSystem}');
      return;
    }
    try {
      androidInfo = await DeviceInfoPlugin().androidInfo;
      deviceModel = androidInfo?.model;
      log('$deviceModel Device');
    } catch (e, st) {
      log('DeviceServiceInit failed: $e', stackTrace: st);
    }
  }
}
