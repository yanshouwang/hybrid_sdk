import 'package:clover/clover.dart';
import 'package:go_router/go_router.dart';
import 'package:hybrid_os_android_example/view_models.dart';
import 'package:hybrid_os_android_example/views.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return ViewModelBinding(
          viewBuilder: (context) => const HomeView(),
          viewModelBuilder: (context) => HomeViewModel(),
        );
      },
      routes: [
        GoRoute(
          path: 'window',
          builder: (context, state) {
            return ViewModelBinding(
              viewBuilder: (context) => const WindowView(),
              viewModelBuilder: (context) => WindowViewModel(),
            );
          },
        ),
      ],
    ),
  ],
);
