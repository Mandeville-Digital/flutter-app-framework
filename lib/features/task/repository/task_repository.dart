import 'dart:async';
import '../domain/task.dart';
import 'i_task_repository.dart';

class TaskRepository implements ITaskRepository {
  final List<Task> _tasks = [];
  final _taskController = StreamController<List<Task>>.broadcast();
  final _taskByIdControllers = <String, StreamController<Task?>>{};

  TaskRepository() {
    _taskController.add(_tasks);
  }

  void _notifyListeners() {
    _taskController.add(List.unmodifiable(_tasks));
    for (final task in _tasks) {
      _taskByIdControllers[task.id]?.add(task);
    }
  }

  @override
  Future<List<Task>> getAll() async => List.unmodifiable(_tasks);

  @override
  Future<Task?> getById(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Task> create(Task task) async {
    _tasks.add(task);
    _notifyListeners();
    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      throw Exception('Task not found');
    }
    _tasks[index] = task;
    _notifyListeners();
    return task;
  }

  @override
  Future<void> delete(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    _notifyListeners();
    _taskByIdControllers[id]?.add(null);
  }

  @override
  Future<Task> completeTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    final updatedTask = _tasks[taskIndex].copyWith(isCompleted: true);
    _tasks[taskIndex] = updatedTask;
    _notifyListeners();
    return updatedTask;
  }

  @override
  Stream<List<Task>> watchAll() => _taskController.stream;

  @override
  Stream<Task?> watchById(String id) {
    _taskByIdControllers.putIfAbsent(
      id, 
      () {
        final controller = StreamController<Task?>.broadcast();
        final task = _tasks.cast<Task?>().firstWhere(
          (t) => t?.id == id,
          orElse: () => null,
        );
        controller.add(task);
        return controller;
      }
    );
    return _taskByIdControllers[id]!.stream;
  }

  void dispose() {
    _taskController.close();
    for (final controller in _taskByIdControllers.values) {
      controller.close();
    }
    _taskByIdControllers.clear();
  }
} 