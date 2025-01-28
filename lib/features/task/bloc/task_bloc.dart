import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/core/events/event_broker.dart';
import '../domain/task.dart';
import '../events/task_events.dart';
import '../repository/i_task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ITaskRepository _repository;
  final EventBroker _eventBroker;

  TaskBloc(this._repository, this._eventBroker) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<CompleteTask>(_onCompleteTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      final tasks = await _repository.getAll();
      emit(TasksLoaded(tasks));
      _eventBroker.publish(TasksLoadedEvent(tasks.length));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      final task = Task(title: event.title, description: event.description);
      await _repository.create(task);
      final tasks = await _repository.getAll();
      emit(TasksLoaded(tasks));
      _eventBroker.publish(TaskAddedEvent(event.title, taskId: task.id));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCompleteTask(CompleteTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      await _repository.completeTask(event.taskId);
      final tasks = await _repository.getAll();
      emit(TasksLoaded(tasks));
      _eventBroker.publish(TaskCompletedEvent(event.taskId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      await _repository.delete(event.taskId);
      final tasks = await _repository.getAll();
      emit(TasksLoaded(tasks));
      _eventBroker.publish(TaskDeletedEvent(event.taskId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
} 