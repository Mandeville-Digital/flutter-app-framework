import 'package:flutter/material.dart';
import '../../domain/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onCompleted;
  final VoidCallback onDeleted;

  const TaskItem({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      onDismissed: (_) => onDeleted(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onCompleted(),
        ),
      ),
    );
  }
} 