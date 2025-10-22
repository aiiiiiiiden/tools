import 'package:flutter/material.dart';
import '../models/sub_task.dart';

class SubtaskListItem extends StatelessWidget {
  final SubTask subtask;
  final Function(String) onToggle;
  final Function(String) onEdit;
  final Function(String) onDelete;

  const SubtaskListItem({
    super.key,
    required this.subtask,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        subtask.title,
        style: TextStyle(
          decoration:
              subtask.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          color: subtask.isDone ? Colors.grey : Colors.black,
        ),
      ),
      leading: Checkbox(
        value: subtask.isDone,
        onChanged: (bool? value) {
          onToggle(subtask.id);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEdit(subtask.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete(subtask.id);
            },
          ),
        ],
      ),
    );
  }
}
