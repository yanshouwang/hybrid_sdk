import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface_platform_interface.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridCorePlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements HybridCorePlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridCorePlatformInterfacePlatform initialPlatform = HybridCorePlatformInterfacePlatform.instance;

  test('$MethodChannelHybridCorePlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridCorePlatformInterface>());
  });

  test('getPlatformVersion', () async {
    HybridCorePlatformInterface hybridCorePlatformInterfacePlugin = HybridCorePlatformInterface();
    MockHybridCorePlatformInterfacePlatform fakePlatform = MockHybridCorePlatformInterfacePlatform();
    HybridCorePlatformInterfacePlatform.instance = fakePlatform;

    expect(await hybridCorePlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
