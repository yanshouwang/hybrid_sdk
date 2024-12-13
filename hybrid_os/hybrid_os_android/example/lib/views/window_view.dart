// import 'package:clover/clover.dart';
// import 'package:flutter/material.dart';
// import 'package:hybrid_os_android_example/view_models.dart';

// class WindowView extends StatelessWidget {
//   const WindowView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ViewModel.of<WindowViewModel>(context);
//     final screenBrightness = viewModel.screenBrightness;
//     final screenBrightnessOverride = screenBrightness != null;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Window'),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(20.0),
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Brightness',
//               style: Theme.of(context).textTheme.titleMedium,
//               textAlign: TextAlign.center,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Override',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 Checkbox(
//                   value: screenBrightnessOverride,
//                   onChanged: screenBrightnessOverride
//                       ? (value) => viewModel.screenBrightness = null
//                       : null,
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Value',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: screenBrightness ?? 0.0,
//                     onChanged: (value) => viewModel.screenBrightness = value,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
