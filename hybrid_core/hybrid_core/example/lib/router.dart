import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'views/views.dart';

final routerConfig = GoRouter(
  initialLocation: '/os',
  debugLogDiagnostics: kDebugMode,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomeView(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/os',
              builder: (context, state) => const OSView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/share',
              builder: (context, state) => const ShareView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
