import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoapp/views/loading_notifier.dart';
import 'package:todoapp/data/todo_entity.dart';

import '../data/model/todo_model.dart';

class TodoNotifier extends StateNotifier<Iterable<TodoModel>?> {
  TodoNotifier(this._read) : super(null);
  final Reader _read;

  Future<void> load() async {
    _read(loadingNotifierProvider.notifier).state = true;

    // final String response = await rootBundle.loadString('assets/db.json');
    // final todos = await todoEntityFromJson(response);

    final todos = Hive.box<TodoModel>('todo');
    await Future.delayed(const Duration(seconds: 2));
    state = todos.values;

    _read(loadingNotifierProvider.notifier).state = false;
  }

  Future<void> create(TodoModel todo) async {
    _read(loadingNotifierProvider.notifier).state = true;

    final db = Hive.box<TodoModel>('todo');
    db.add(todo);
    load();
    // await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> delete(TodoModel todo) async {
    _read(loadingNotifierProvider.notifier).state = true;
    todo.delete();
    load();
    // await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> update(TodoModel todo, bool flag) async {
    _read(loadingNotifierProvider.notifier).state = true;
    todo.isComplete = flag.toString();
    todo.save();
    load();
  }
}
