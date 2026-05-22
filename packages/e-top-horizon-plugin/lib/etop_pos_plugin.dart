import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import 'etop_pos_plugin_platform_interface.dart';
import 'in_ap/In_app_pos.dart';

class EtopPosPlugin {
  Future<String?> getPlatformVersion() {
    return EtopPosPluginPlatform.instance.getPlatformVersion();
  }

  Future<Void?> prepDevice(
      String terminalID, Map<String, String?> terminalConfig) {
    return EtopPosPluginPlatform.instance
        .prepDevice(terminalID, terminalConfig);
  }

  Future<Void?> pay(Map transactionAmount) {
    return EtopPosPluginPlatform.instance.pay(transactionAmount);
  }

  Future<Void?> balanceInquiry(Map transactionAmount) {
    return EtopPosPluginPlatform.instance.balanceInquiry(transactionAmount);
  }

  Future<Void?> print() {
    return EtopPosPluginPlatform.instance.printReceipt();
  }

  Future<Void?> printEOD({Map? map}) {
    return EtopPosPluginPlatform.instance.printEOD(map!);
  }

  Future<Void?> reprint({Map? map}) {
    return EtopPosPluginPlatform.instance.reprint(map!);
  }

  Future<String?> getSerialNo() {
    return EtopPosPluginPlatform.instance.getSerialNo();
  }

  Future openEOD(
      {required BuildContext context,
      required String userID,
      required String baseRoute}) async {
    InAppPOS().eodView(context: context, userId: userID, baseURl: baseRoute);
  }

  Future ePayment(
      {required BuildContext context,
      Map? terminalInfo,
      String? userID}) async {
    InAppPOS().start(context, terminalInfo: terminalInfo, userID: userID);
  }
}
