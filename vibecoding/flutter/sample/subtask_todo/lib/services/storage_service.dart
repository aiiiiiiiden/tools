import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class StorageService {
  static const String _todosKey = 'todos';

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_todosKey, jsonString);
  }

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_todosKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Todo.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
