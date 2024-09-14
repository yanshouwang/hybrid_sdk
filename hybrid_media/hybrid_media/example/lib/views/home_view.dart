import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_media/hybrid_media.dart';
import 'package:hybrid_media_example/view_models.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hybrid Media'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                viewModel.ringerMode.icon,
                size: 120.0,
              ),
            ),
            buildVolumeController(
              title: 'Music',
              minVolume: viewModel.musicMinVolume,
              maxVolume: viewModel.musicMaxVolume,
              volume: viewModel.musicVolume,
              onMuteChanged: () => viewModel.toggleMusicMute(),
              onChanged: (value) {
                if (value == viewModel.musicVolume) {
                  return;
                }
                viewModel.musicVolume = value;
              },
            ),
            buildVolumeController(
              title: 'Ring',
              minVolume: viewModel.ringMinVolume,
              maxVolume: viewModel.ringMaxVolume,
              volume: viewModel.ringVolume,
              onMuteChanged: () => viewModel.toggleRingMute(),
              onChanged: (value) {
                if (value == viewModel.ringVolume) {
                  return;
                }
                viewModel.ringVolume = value;
              },
            ),
            buildVolumeController(
              title: 'Notification',
              minVolume: viewModel.notificationMinVolume,
              maxVolume: viewModel.notificationMaxVolume,
              volume: viewModel.notificationVolume,
              onMuteChanged: () => viewModel.toggleNotificationMute(),
              onChanged: (value) {
                if (value == viewModel.notificationVolume) {
                  return;
                }
                viewModel.notificationVolume = value;
              },
            ),
            buildVolumeController(
              title: 'Alarm',
              minVolume: viewModel.alarmMinVolume,
              maxVolume: viewModel.alarmMaxVolume,
              volume: viewModel.alarmVolume,
              onMuteChanged: () => viewModel.toggleAlarmMute(),
              onChanged: (value) {
                if (value == viewModel.alarmVolume) {
                  return;
                }
                viewModel.alarmVolume = value;
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildVolumeController({
    required String title,
    required int minVolume,
    required int maxVolume,
    required int volume,
    required VoidCallback onMuteChanged,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title),
        Row(
          children: [
            IconButton(
              onPressed: onMuteChanged,
              icon: Icon(
                volume > 0 ? Icons.volume_up : Icons.volume_mute,
              ),
            ),
            Expanded(
              child: Slider(
                min: minVolume.toDouble(),
                max: maxVolume.toDouble(),
                value: volume.toDouble(),
                onChanged: (value) {
                  final intValue = value.toInt();
                  onChanged(intValue);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

extension on RingerMode {
  IconData get icon {
    switch (this) {
      case RingerMode.silent:
        return Icons.notifications_off_outlined;
      case RingerMode.vibrate:
        return Icons.vibration;
      case RingerMode.normal:
        return Icons.notifications_on_outlined;
    }
  }
}
