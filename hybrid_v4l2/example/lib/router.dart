import 'package:clover/clover.dart';
import 'package:go_router/go_router.dart';
import 'package:hybrid_v4l2_example/view_models.dart';
import 'package:hybrid_v4l2_example/views.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ViewModelBinding(
        viewBuilder: (context) => const HomeView(),
        viewModelBuilder: (context) => HomeViewModel(),
      ),
    ),
  ],
);
