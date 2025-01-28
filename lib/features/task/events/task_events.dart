import '../../core/events/event.dart';

class TaskAddedEvent extends Event {
  final String title;
  const TaskAddedEvent(this.title, {required String taskId}) : super(eventId: taskId);

  @override
  String toString() => '${super.toString()}, title: $title';
}

class TaskCompletedEvent extends Event {
  const TaskCompletedEvent(String taskId) : super(eventId: taskId);
}

class TaskDeletedEvent extends Event {
  const TaskDeletedEvent(String taskId) : super(eventId: taskId);
}

class TasksLoadedEvent extends Event {
  final int count;
  const TasksLoadedEvent(this.count) : super();

  @override
  String toString() => 'count: $count';
} 