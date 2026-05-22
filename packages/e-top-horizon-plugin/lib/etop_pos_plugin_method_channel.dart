import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'etop_pos_plugin_platform_interface.dart';

class MethodChannelEtopPosPlugin extends EtopPosPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('etop_pos_plugin');

  @override
  Future<String?> getSerialNo() async {
    final serialNo = await methodChannel.invokeMethod<String>('getSerialNo');
    return serialNo;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Void?> prepDevice(
      String terminalID, Map<String, String?> terminalConfig) async {
    await methodChannel.invokeMethod<void>(
      'prep',
      {"terminalID": terminalID, "terminalConfig": terminalConfig},
    );
    return null;
  }

  @override
  Future<Void?> pay(Map transactionData) async {
    final payAmount = await methodChannel
        .invokeListMethod("pay", {"transactionData": transactionData});
    print("Method Chanel=======================> $transactionData");
    return null;
  }

  @override
  Future<Void?> balanceInquiry(Map transactionData) async {
    await methodChannel.invokeListMethod(
        "balance_inquiry", {"transactionData": transactionData});
    print("Method Chanel=======================> $transactionData");
    return null;
  }

  @override
  Future<Void?> printReceipt() async {
    final version = await methodChannel.invokeMethod('print');
    return version;
  }

  @override
  Future<Void?> printEOD(Map data2) async {
    final version = await methodChannel.invokeMethod("eod", {
      "transactionData": data2,
    });
  }

  @override
  Future<Void?> reprint(Map data) async {
    final version = await methodChannel.invokeMethod("reprint", {
      "transactionData": data,
    });
  }
}

// {institutionName: Holy Cross Secondary School, institutionID: 123456, level: secondary, studentClass: SS 2, phoneNumber: 055667777779, email: null, tid: 2ETP0012, amount: 2000}
