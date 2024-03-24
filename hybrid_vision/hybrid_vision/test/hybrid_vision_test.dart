import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_vision/hybrid_vision.dart';
import 'package:hybrid_vision/hybrid_vision_platform_interface.dart';
import 'package:hybrid_vision/hybrid_vision_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridVisionPlatform
    with MockPlatformInterfaceMixin
    implements HybridVisionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridVisionPlatform initialPlatform = HybridVisionPlatform.instance;

  test('$MethodChannelHybridVision is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridVision>());
  });

  test('getPlatformVersion', () async {
    HybridVision hybridVisionPlugin = HybridVision();
    MockHybridVisionPlatform fakePlatform = MockHybridVisionPlatform();
    HybridVisionPlatform.instance = fakePlatform;

    expect(await hybridVisionPlugin.getPlatformVersion(), '42');
  });
}
