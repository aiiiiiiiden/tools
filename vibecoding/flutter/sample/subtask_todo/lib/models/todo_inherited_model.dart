import 'package:flutter/widgets.dart';
import 'todo.dart';
import 'sub_task.dart';

enum TodoAspect {
  title,
  description,
  isCompleted,
  subtasks,
  createdAt,
}

class TodoInheritedModel extends InheritedModel<TodoAspect> {
  final List<Todo> todos;
  final Function(Todo) addTodoCallback;
  final Function(Todo) updateTodoCallback;
  final Function(String) deleteTodoCallback;
  final Function(String) toggleTodoCompleteCallback;
  final Function(String todoId, SubTask subtask) addSubtaskCallback;
  final Function(String todoId, SubTask updatedSubtask) updateSubtaskCallback;
  final Function(String todoId, String subtaskId) deleteSubtaskCallback;
  final Function(String todoId, String subtaskId) toggleSubtaskCompleteCallback;

  const TodoInheritedModel({
    super.key,
    required this.todos,
    required this.addTodoCallback,
    required this.updateTodoCallback,
    required this.deleteTodoCallback,
    required this.toggleTodoCompleteCallback,
    required this.addSubtaskCallback,
    required this.updateSubtaskCallback,
    required this.deleteSubtaskCallback,
    required this.toggleSubtaskCompleteCallback,
    required super.child,
  });

  static TodoInheritedModel? maybeOf(BuildContext context,
      [TodoAspect? aspect]) {
    return InheritedModel.inheritFrom<TodoInheritedModel>(context,
        aspect: aspect);
  }

  static TodoInheritedModel of(BuildContext context, [TodoAspect? aspect]) {
    final TodoInheritedModel? result = maybeOf(context, aspect);
    assert(result != null, 'No TodoInheritedModel found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant TodoInheritedModel oldWidget) {
    return todos != oldWidget.todos ||
        addTodoCallback != oldWidget.addTodoCallback ||
        updateTodoCallback != oldWidget.updateTodoCallback ||
        deleteTodoCallback != oldWidget.deleteTodoCallback ||
        toggleTodoCompleteCallback != oldWidget.toggleTodoCompleteCallback ||
        addSubtaskCallback != oldWidget.addSubtaskCallback ||
        updateSubtaskCallback != oldWidget.updateSubtaskCallback ||
        deleteSubtaskCallback != oldWidget.deleteSubtaskCallback ||
        toggleSubtaskCompleteCallback !=
            oldWidget.toggleSubtaskCompleteCallback;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant TodoInheritedModel oldWidget,
    Set<TodoAspect> dependencies,
  ) {
    if (todos.length != oldWidget.todos.length) {
      return true;
    }
    for (int i = 0; i < todos.length; i++) {
      final newTodo = todos[i];
      final oldTodo = oldWidget.todos[i];

      if (newTodo.id != oldTodo.id) {
        return true;
      }

      if (dependencies.contains(TodoAspect.title) &&
          newTodo.title != oldTodo.title) {
        return true;
      }
      if (dependencies.contains(TodoAspect.description) &&
          newTodo.description != oldTodo.description) {
        return true;
      }
      if (dependencies.contains(TodoAspect.isCompleted) &&
          newTodo.isCompleted != oldTodo.isCompleted) {
        return true;
      }
      if (dependencies.contains(TodoAspect.createdAt) &&
          newTodo.createdAt != oldTodo.createdAt) {
        return true;
      }
      if (dependencies.contains(TodoAspect.subtasks) &&
          newTodo.subtasks != oldTodo.subtasks) {
        return true;
      }
    }
    return false;
  }
}
