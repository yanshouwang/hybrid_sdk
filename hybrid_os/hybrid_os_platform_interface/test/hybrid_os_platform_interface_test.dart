import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface_platform_interface.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridOsPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements HybridOsPlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridOsPlatformInterfacePlatform initialPlatform = HybridOsPlatformInterfacePlatform.instance;

  test('$MethodChannelHybridOsPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridOsPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    HybridOsPlatformInterface hybridOsPlatformInterfacePlugin = HybridOsPlatformInterface();
    MockHybridOsPlatformInterfacePlatform fakePlatform = MockHybridOsPlatformInterfacePlatform();
    HybridOsPlatformInterfacePlatform.instance = fakePlatform;

    expect(await hybridOsPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
