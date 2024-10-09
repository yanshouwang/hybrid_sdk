import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:hybrid_v4l2_example/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final mappedBuf = viewModel.mappedBuf;
    return Scaffold(
      body: V4L2View(
        mappedBuf: mappedBuf,
      ),
    );
  }
}
