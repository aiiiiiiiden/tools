import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../models/todo_inherited_model.dart';
import 'package:subtask_todo/widgets/add_edit_dialog.dart';
import 'package:subtask_todo/widgets/add_edit_subtask_dialog.dart';
import 'package:subtask_todo/widgets/subtask_list_item.dart';
import 'package:subtask_todo/models/sub_task.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoInheritedModel = TodoInheritedModel.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(todo.description),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (bool? value) {
            todoInheritedModel.toggleTodoCompleteCallback(todo.id);
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedTodo = await showDialog<Todo>(
                  context: context,
                  builder: (context) => AddEditTodoDialog(todo: todo),
                );
                if (updatedTodo != null) {
                  todoInheritedModel.updateTodoCallback(updatedTodo);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Todo'),
                    content: Text(
                        'Are you sure you want to delete "${todo.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmDelete == true) {
                  todoInheritedModel.deleteTodoCallback(todo.id);
                }
              },
            ),
          ],
        ),
        children: [
          // Subtasks will be listed here
          if (todo.subtasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('No subtasks yet.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todo.subtasks.length,
              itemBuilder: (context, index) {
                final subtask = todo.subtasks[index];
                return SubtaskListItem(
                  subtask: subtask,
                  onToggle: (subtaskId) {
                    todoInheritedModel.toggleSubtaskCompleteCallback(
                        todo.id, subtaskId);
                  },
                  onEdit: (subtaskId) async {
                    final updatedSubtask = await showDialog<SubTask>(
                      context: context,
                      builder: (context) =>
                          AddEditSubtaskDialog(subtask: subtask),
                    );
                    if (updatedSubtask != null) {
                      todoInheritedModel.updateSubtaskCallback(
                          todo.id, updatedSubtask);
                    }
                  },
                  onDelete: (subtaskId) async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Subtask'),
                        content: Text(
                            'Are you sure you want to delete "${subtask.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      todoInheritedModel.deleteSubtaskCallback(
                          todo.id, subtaskId);
                    }
                  },
                );
              },
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Subtask'),
                onPressed: () async {
                  final newSubtask = await showDialog<SubTask>(
                    context: context,
                    builder: (context) => const AddEditSubtaskDialog(),
                  );
                  if (newSubtask != null) {
                    todoInheritedModel.addSubtaskCallback(todo.id, newSubtask);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
