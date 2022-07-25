import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoapp/misc/routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routes = ref.read(routesProvider);

  String? redirect(GoRouterState state) {
    return '/home';
  }

  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    
    routes: routes,
  );
});
