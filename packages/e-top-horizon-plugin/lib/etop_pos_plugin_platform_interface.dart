import 'dart:ffi';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'etop_pos_plugin_method_channel.dart';

abstract class EtopPosPluginPlatform extends PlatformInterface {
  /// Constructs a EtopPosPluginPlatform.
  EtopPosPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EtopPosPluginPlatform _instance = MethodChannelEtopPosPlugin();

  /// The default instance of [EtopPosPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelEtopPosPlugin].
  static EtopPosPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EtopPosPluginPlatform] when
  /// they register themselves.
  static set instance(EtopPosPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> prepDevice(
      String terminalID, Map<String, String?> terminalConfig) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> pay(Map transactionData) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> balanceInquiry(Map transactionData) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> printReceipt() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> printEOD(Map data) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getSerialNo() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Void?> reprint(Map data) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
