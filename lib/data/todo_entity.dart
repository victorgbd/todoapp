import 'dart:convert';

Future<List<TodoEntity>> todoEntityFromJson(String str) async =>
    List<TodoEntity>.from(
        await json.decode(str).map((x) => TodoEntity.fromJson(x)));

String todoEntityToJson(List<TodoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoEntity {
  TodoEntity({
    required this.content,
    required this.date,
    required this.isComplete,
  });

  String content;
  String date;
  String isComplete;

  factory TodoEntity.fromJson(Map<String, dynamic> json) => TodoEntity(
        content: json["content"],
        date: json["date"],
        isComplete: json["isComplete"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "date": date,
        "isComplete": isComplete,
      };
}
