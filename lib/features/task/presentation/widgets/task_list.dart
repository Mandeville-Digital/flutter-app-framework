import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is! TasksLoaded) {
          return const SizedBox.shrink();
        }

        final tasks = state.tasks;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItem(
              task: task,
              onCompleted: () => context.read<TaskBloc>().add(CompleteTask(task.id)),
              onDeleted: () => context.read<TaskBloc>().add(DeleteTask(task.id)),
            );
          },
        );
      },
    );
  }
} 