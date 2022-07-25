import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  late String content;
  @HiveField(1)
  late String date;
  @HiveField(2)
  late String isComplete;
}
