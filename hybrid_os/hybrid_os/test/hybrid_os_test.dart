import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_os/hybrid_os.dart';
import 'package:hybrid_os/hybrid_os_platform_interface.dart';
import 'package:hybrid_os/hybrid_os_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHybridOsPlatform
    with MockPlatformInterfaceMixin
    implements HybridOsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HybridOsPlatform initialPlatform = HybridOsPlatform.instance;

  test('$MethodChannelHybridOs is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHybridOs>());
  });

  test('getPlatformVersion', () async {
    HybridOs hybridOsPlugin = HybridOs();
    MockHybridOsPlatform fakePlatform = MockHybridOsPlatform();
    HybridOsPlatform.instance = fakePlatform;

    expect(await hybridOsPlugin.getPlatformVersion(), '42');
  });
}
