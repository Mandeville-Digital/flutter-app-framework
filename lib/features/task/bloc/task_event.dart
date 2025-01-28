part of 'task_bloc.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class AddTask extends TaskEvent {
  final String title;
  final String? description;

  const AddTask(this.title, {this.description});
}

class CompleteTask extends TaskEvent {
  final String taskId;

  const CompleteTask(this.taskId);
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);
} 