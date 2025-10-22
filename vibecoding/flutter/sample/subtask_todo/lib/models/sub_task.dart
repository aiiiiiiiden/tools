import 'package:uuid/uuid.dart';

class SubTask {
  final String id;
  final String title;
  final bool isDone;

  SubTask({
    String? id,
    required this.title,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4();

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  SubTask copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
