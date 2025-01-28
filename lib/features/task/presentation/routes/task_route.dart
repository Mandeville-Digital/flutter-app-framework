import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../screens/task_screen.dart';
import '../../repository/i_task_repository.dart';
import '../../../core/events/event_broker.dart';

class TaskRoute {
  static Widget builder(BuildContext context) {
    return TaskScreen(
      taskRepository: GetIt.I<ITaskRepository>(),
      eventBroker: GetIt.I<EventBroker>(),
    );
  }
} 