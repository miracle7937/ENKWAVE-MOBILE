import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etop_pos_plugin/etop_pos_plugin_method_channel.dart';

void main() {
  MethodChannelEtopPosPlugin platform = MethodChannelEtopPosPlugin();
  const MethodChannel channel = MethodChannel('etop_pos_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
