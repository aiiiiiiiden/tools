import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../models/todo_inherited_model.dart';
import 'package:subtask_todo/widgets/todo_list_item.dart';
import 'package:subtask_todo/widgets/add_edit_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoInheritedModel = TodoInheritedModel.of(context);
    final todos = todoInheritedModel.todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subtask Todo'),
      ),
      body: todos.isEmpty
          ? const Center(
              child: Text('No todos yet! Add one using the + button.'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoListItem(todo: todo);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await showDialog<Todo>(
            context: context,
            builder: (context) => const AddEditTodoDialog(),
          );
          if (newTodo != null) {
            todoInheritedModel.addTodoCallback(newTodo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
