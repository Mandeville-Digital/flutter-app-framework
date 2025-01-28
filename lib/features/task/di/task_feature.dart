import 'package:get_it/get_it.dart';
import '../repository/i_task_repository.dart';
import '../repository/task_repository.dart';

extension TaskFeatureRegistration on GetIt {
  Future<void> registerTaskFeature() async {
    // Register repository
    registerSingleton<ITaskRepository>(TaskRepository());
  }
} 