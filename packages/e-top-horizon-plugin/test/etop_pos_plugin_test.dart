import 'dart:ffi';

import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:etop_pos_plugin/etop_pos_plugin_method_channel.dart';
import 'package:etop_pos_plugin/etop_pos_plugin_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEtopPosPluginPlatform
    with MockPlatformInterfaceMixin
    implements EtopPosPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getSerialNo() {
    // TODO: implement getSerialNo
    throw UnimplementedError();
  }

  @override
  Future<Void?> pay(Map transactionData) {
    // TODO: implement pay
    throw UnimplementedError();
  }

  @override
  Future<Void?> prepDevice(
      String terminalID, Map<String, String?> terminalConfig) {
    // TODO: implement prepDevice
    throw UnimplementedError();
  }

  @override
  Future<Void?> printEOD(Map data, String institution) {
    // TODO: implement printEOD
    throw UnimplementedError();
  }

  @override
  Future<Void?> printReceipt() {
    // TODO: implement printReceipt
    throw UnimplementedError();
  }
}

void main() {
  final EtopPosPluginPlatform initialPlatform = EtopPosPluginPlatform.instance;

  test('$MethodChannelEtopPosPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEtopPosPlugin>());
  });

  test('getPlatformVersion', () async {
    EtopPosPlugin etopPosPlugin = EtopPosPlugin();
    MockEtopPosPluginPlatform fakePlatform = MockEtopPosPluginPlatform();
    EtopPosPluginPlatform.instance = fakePlatform;

    expect(await etopPosPlugin.getPlatformVersion(), '42');
  });
}
