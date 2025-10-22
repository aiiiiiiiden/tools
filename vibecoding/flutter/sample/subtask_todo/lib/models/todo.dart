import 'package:uuid/uuid.dart';
import 'sub_task.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final List<SubTask> subtasks;
  final DateTime createdAt;

  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    List<SubTask>? subtasks,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        subtasks = subtasks ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      subtasks: (json['subtasks'] as List<dynamic>)
          .map((e) => SubTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'subtasks': subtasks.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    List<SubTask>? subtasks,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
