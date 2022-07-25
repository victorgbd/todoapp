import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../views/new_todo_view.dart';

final routesProvider = Provider<List<GoRoute>>((ref) {
  return <GoRoute>[
    GoRoute(
      name: '/',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: '/home',
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      name: '/new',
      path: '/new',
      builder: (context, state) => const NewTodo(),
    ),
  ];
});
