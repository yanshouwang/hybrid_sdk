import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface_platform_interface.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridVisionPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements HybridVisionPlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridVisionPlatformInterfacePlatform initialPlatform = HybridVisionPlatformInterfacePlatform.instance;

  test('$MethodChannelHybridVisionPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridVisionPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    HybridVisionPlatformInterface hybridVisionPlatformInterfacePlugin = HybridVisionPlatformInterface();
    MockHybridVisionPlatformInterfacePlatform fakePlatform = MockHybridVisionPlatformInterfacePlatform();
    HybridVisionPlatformInterfacePlatform.instance = fakePlatform;

    expect(await hybridVisionPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
