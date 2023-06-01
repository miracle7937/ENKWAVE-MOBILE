import 'dart:developer';

import 'package:device_info/device_info.dart';

class DeviceServiceInit {
  static AndroidDeviceInfo? androidInfo;
  static String telpoDevice = "TPS900";
  static initialize() async {
    androidInfo = await DeviceInfoPlugin().androidInfo;
    log("${androidInfo?.model} Device");
    // if (androidInfo?.model == "TPS900") {
    //   return;
    // }
  }
}
