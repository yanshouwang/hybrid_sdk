import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_core/hybrid_core.dart';
import 'package:hybrid_core/hybrid_core_platform_interface.dart';
import 'package:hybrid_core/hybrid_core_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridCorePlatform
    with MockPlatformInterfaceMixin
    implements HybridCorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridCorePlatform initialPlatform = HybridCorePlatform.instance;

  test('$MethodChannelHybridCore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridCore>());
  });

  test('getPlatformVersion', () async {
    HybridCore hybridCorePlugin = HybridCore();
    MockHybridCorePlatform fakePlatform = MockHybridCorePlatform();
    HybridCorePlatform.instance = fakePlatform;

    expect(await hybridCorePlugin.getPlatformVersion(), '42');
  });
}
