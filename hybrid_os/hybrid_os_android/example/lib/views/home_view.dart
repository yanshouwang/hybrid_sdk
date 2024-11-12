import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hybrid_os_android/hybrid_os_android.dart';
import 'package:hybrid_os_android_example/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final sdk = 'Android ${viewModel.sdk}';
    final upsideDownCakeOrLater = viewModel.upsideDownCakeOrLater;
    final canWriteSettings = viewModel.canWriteSettings;
    final screenBrightnessMode = viewModel.brightnessMode;
    final screenBrightness = viewModel.brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OS'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              sdk,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Android 34+',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '$upsideDownCakeOrLater',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: canWriteSettings
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              onPressed: () => viewModel.startManageWriteSettingsActivity(),
              child: Text(canWriteSettings
                  ? 'Can write settings'
                  : 'Can not write settings'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Brightness',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Text(
                  'Automatic Mode',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Checkbox(
                  value: screenBrightnessMode == ScreenBrightnessMode.automatic,
                  onChanged: canWriteSettings
                      ? (value) {
                          viewModel.brightnessMode = value == true
                              ? ScreenBrightnessMode.automatic
                              : ScreenBrightnessMode.manual;
                        }
                      : null,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Value',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                  child: Slider(
                    value: screenBrightness,
                    onChanged: canWriteSettings &&
                            screenBrightnessMode == ScreenBrightnessMode.manual
                        ? (value) {
                            viewModel.brightness = value;
                          }
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => context.go('/window'),
              child: const Text('Window'),
            ),
          ],
        ),
      ),
    );
  }
}
