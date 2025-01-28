import '../domain/task.dart';
import '../../core/repository/i_repository.dart';

abstract class ITaskRepository extends IRepository<Task> {
  Future<Task> completeTask(String taskId);
} 