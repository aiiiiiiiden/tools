import 'package:flutter/material.dart';
import 'package:subtask_todo/models/todo.dart';
import 'package:subtask_todo/models/todo_inherited_model.dart';
import 'package:subtask_todo/screens/home_screen.dart';
import 'package:subtask_todo/services/storage_service.dart';
import 'package:subtask_todo/models/sub_task.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> _todos = [];
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final loadedTodos = await _storageService.loadTodos();
    setState(() {
      _todos = loadedTodos;
    });
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos = List.from(_todos)..add(todo);
    });
    _storageService.saveTodos(_todos);
  }

  void _updateTodo(Todo updatedTodo) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        _todos = List.from(_todos)..[index] = updatedTodo;
      }
    });
    _storageService.saveTodos(_todos);
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos = List.from(_todos)..removeWhere((todo) => todo.id == id);
    });
    _storageService.saveTodos(_todos);
  }

  void _toggleTodoComplete(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final currentTodo = _todos[index];
        final newIsCompleted = !currentTodo.isCompleted;
        final updatedSubtasks = currentTodo.subtasks
            .map((subtask) => subtask.copyWith(isDone: newIsCompleted))
            .toList();
        _todos = List.from(_todos);
        _todos[index] = currentTodo.copyWith(
          isCompleted: newIsCompleted,
          subtasks: updatedSubtasks,
        );
      }
    });
    _storageService.saveTodos(_todos);
  }

  void _addSubtask(String todoId, SubTask subtask) {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
      if (todoIndex != -1) {
        final updatedSubtasks = List<SubTask>.from(_todos[todoIndex].subtasks)
          ..add(subtask);
        final updatedTodo = _todos[todoIndex].copyWith(subtasks: updatedSubtasks);
        _todos = List.from(_todos)..[todoIndex] = updatedTodo;
      }
    });
    _storageService.saveTodos(_todos);
  }

  void _updateSubtask(String todoId, SubTask updatedSubtask) {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
      if (todoIndex != -1) {
        final subtaskIndex = _todos[todoIndex]
            .subtasks
            .indexWhere((sub) => sub.id == updatedSubtask.id);
        if (subtaskIndex != -1) {
          final updatedSubtasks = List<SubTask>.from(_todos[todoIndex].subtasks);
          updatedSubtasks[subtaskIndex] = updatedSubtask;
          final updatedTodo = _todos[todoIndex].copyWith(subtasks: updatedSubtasks);
          _todos = List.from(_todos)..[todoIndex] = updatedTodo;
        }
      }
    });
    _storageService.saveTodos(_todos);
  }

  void _deleteSubtask(String todoId, String subtaskId) {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
      if (todoIndex != -1) {
        final updatedSubtasks = List<SubTask>.from(_todos[todoIndex].subtasks)
          ..removeWhere((sub) => sub.id == subtaskId);
        final updatedTodo = _todos[todoIndex].copyWith(subtasks: updatedSubtasks);
        _todos = List.from(_todos)..[todoIndex] = updatedTodo;
      }
    });
    _storageService.saveTodos(_todos);
  }

  void _toggleSubtaskComplete(String todoId, String subtaskId) {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
      if (todoIndex != -1) {
        final subtaskIndex =
            _todos[todoIndex].subtasks.indexWhere((sub) => sub.id == subtaskId);
        if (subtaskIndex != -1) {
          final updatedSubtasks =
              List<SubTask>.from(_todos[todoIndex].subtasks);
          updatedSubtasks[subtaskIndex] = updatedSubtasks[subtaskIndex]
              .copyWith(isDone: !updatedSubtasks[subtaskIndex].isDone);
          _todos[todoIndex] =
              _todos[todoIndex].copyWith(subtasks: updatedSubtasks);
        }
      }
    });
    _storageService.saveTodos(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return TodoInheritedModel(
      todos: _todos,
      addTodoCallback: _addTodo,
      updateTodoCallback: _updateTodo,
      deleteTodoCallback: _deleteTodo,
      toggleTodoCompleteCallback: _toggleTodoComplete,
      addSubtaskCallback: _addSubtask,
      updateSubtaskCallback: _updateSubtask,
      deleteSubtaskCallback: _deleteSubtask,
      toggleSubtaskCompleteCallback: _toggleSubtaskComplete,
      child: MaterialApp(
        title: 'Subtask Todo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
