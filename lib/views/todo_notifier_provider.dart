import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoapp/data/todo_entity.dart';
import 'package:todoapp/views/todo_notifier.dart';

import '../data/model/todo_model.dart';

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, Iterable<TodoModel>?>((ref) {
  return TodoNotifier(ref.read);
});
