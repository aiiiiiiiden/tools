import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/sub_task.dart';

class AddEditSubtaskDialog extends StatefulWidget {
  final SubTask? subtask;

  const AddEditSubtaskDialog({super.key, this.subtask});

  @override
  State<AddEditSubtaskDialog> createState() => _AddEditSubtaskDialogState();
}

class _AddEditSubtaskDialogState extends State<AddEditSubtaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subtask?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subtask == null ? 'Add Subtask' : 'Edit Subtask'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Subtask Title'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newSubtask = SubTask(
                id: widget.subtask?.id ?? const Uuid().v4(),
                title: _titleController.text,
                isDone: widget.subtask?.isDone ?? false,
              );
              Navigator.of(context).pop(newSubtask);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
