import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import '../widgets/task_list.dart';
import '../widgets/task_input.dart';
import '../../repository/i_task_repository.dart';
import '../../../core/events/event_broker.dart';

class TaskScreen extends StatelessWidget {
  final ITaskRepository taskRepository;
  final EventBroker eventBroker;

  const TaskScreen({
    super.key,
    required this.taskRepository,
    required this.eventBroker,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository,
        eventBroker,
      )..add(const LoadTasks()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Todo List'),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading tasks...'),
                  ],
                ),
              );
            }

            if (state is TaskError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load tasks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.read<TaskBloc>().add(const LoadTasks()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                const TaskInput(),
                Expanded(
                  child: state is TasksLoaded && state.tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks yet. Add one to get started!'),
                        )
                      : const TaskList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 