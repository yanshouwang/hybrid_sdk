import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_adb_macos/hybrid_adb_macos.dart';
import 'package:hybrid_adb_macos/hybrid_adb_macos_platform_interface.dart';
import 'package:hybrid_adb_macos/hybrid_adb_macos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridAdbMacosPlatform
    with MockPlatformInterfaceMixin
    implements HybridAdbMacosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridAdbMacosPlatform initialPlatform = HybridAdbMacosPlatform.instance;

  test('$MethodChannelHybridAdbMacos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridAdbMacos>());
  });

  test('getPlatformVersion', () async {
    HybridAdbMacos hybridAdbMacosPlugin = HybridAdbMacos();
    MockHybridAdbMacosPlatform fakePlatform = MockHybridAdbMacosPlatform();
    HybridAdbMacosPlatform.instance = fakePlatform;

    expect(await hybridAdbMacosPlugin.getPlatformVersion(), '42');
  });
}
