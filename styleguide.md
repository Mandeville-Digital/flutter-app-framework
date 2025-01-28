# Style Guide

This document outlines the coding conventions and best practices for our Flutter application. For project setup, architecture overview, and feature development guides, please refer to our [README.md](README.md).

## Table of Contents
- [Code Style](#code-style)
- [Testing Practices](#testing-practices)
- [Documentation Standards](#documentation-standards)
- [Error Handling](#error-handling)
- [UI/UX Guidelines](#uiux-guidelines)
- [BLoC Pattern Implementation](#bloc-pattern-implementation)

## Code Style

### Import Organization
1. Dart imports
2. Flutter imports
3. Third-party package imports
4. Project imports
5. Relative imports

Example:
```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:appconcept/features/core/events/event.dart';
import 'package:appconcept/features/task/domain/task.dart';

import '../services/task_service.dart';
```

### Naming Conventions

#### Variables and Methods
- Use camelCase for variable and method names
- Use verb phrases for method names
- Use noun phrases for variable names
- Prefix private members with underscore
- Be descriptive but concise

Good:
```dart
void updateUserProfile(UserProfile profile)
final List<Task> completedTasks
void _handleTapEvent()
```

Bad:
```dart
void update(var data)
final List<Task> l
void handleIt()
```

### Code Organization
- Keep files under 300 lines
- Order class members logically:
  1. Static fields
  2. Instance fields
  3. Constructors
  4. Public methods
  5. Private methods
  6. Overridden methods last

## Testing Practices

### Test Structure
- Follow the Arrange-Act-Assert pattern
- Use meaningful test descriptions
- Test one thing per test
- Keep tests focused and simple

Example:
```dart
test('should complete task when marked as done', () async {
  // Arrange
  final task = Task(id: 'test-id', title: 'Test');
  when(mockRepository.completeTask(task.id))
      .thenAnswer((_) async => task.copyWith(isCompleted: true));

  // Act
  await controller.completeTask(task.id);

  // Assert
  verify(mockRepository.completeTask(task.id)).called(1);
  expect(controller.items.first.isCompleted, isTrue);
});
```

### Mock Usage Best Practices
- Keep mock setup in setUp method
- Reset mocks between tests if needed
- Verify important interactions
- Use specific matchers for better error messages

## Documentation Standards

### Code Comments
- Write self-documenting code
- Add comments only when necessary
- Explain "why" not "what"
- Use /// for documentation comments
- Document public APIs

Example:
```dart
/// Completes a task and notifies all listeners.
/// 
/// Throws [TaskNotFoundException] if the task doesn't exist.
Future<void> completeTask(String taskId) async {
  // Implementation
}
```

## Error Handling

### Exception Handling Patterns
- Create custom exceptions for domain-specific errors
- Handle errors at appropriate levels
- Provide meaningful error messages
- Log errors appropriately

Example:
```dart
try {
  await repository.saveTask(task);
} on NetworkException catch (e) {
  _handleNetworkError(e);
} on ValidationException catch (e) {
  _handleValidationError(e);
} catch (e) {
  _handleUnexpectedError(e);
}
```

### Error Messages
- Include relevant context
- Make user-facing messages friendly
- Log technical details for debugging
- Use consistent error message formats

## UI/UX Guidelines

### Widget Best Practices
- Keep widgets focused and small
- Extract reusable widgets
- Use const constructors when possible
- Follow Flutter's widget composition patterns

### Performance Optimization
- Use const constructors
- Implement shouldRebuild in custom widgets
- Avoid unnecessary rebuilds
- Profile and optimize when needed

### Accessibility Standards
- Add semantic labels
- Support screen readers
- Consider keyboard navigation
- Test with accessibility tools
- Use sufficient color contrast
- Provide text scaling support 

## BLoC Pattern Implementation

### 1. BLoC Structure
```dart
// Events
abstract class TaskEvent {
  const TaskEvent();
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

// States
abstract class TaskState {
  const TaskState();
}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  const TasksLoaded(this.tasks);
}

// BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ITaskRepository _repository;
  
  TaskBloc(this._repository) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
  }
  
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    // Implementation
  }
}
```

### 2. Naming Conventions

- **BLoCs**: Suffix with `Bloc` (e.g., `TaskBloc`)
- **Events**: Verb-based names (e.g., `LoadTasks`, `AddTask`)
- **States**: Describe the state (e.g., `TasksLoaded`, `TaskError`)
- **Event Handlers**: Prefix with `_on` (e.g., `_onLoadTasks`)

### 3. File Organization

```
feature/
├── bloc/
│   ├── feature_bloc.dart     # Main BLoC file
│   ├── feature_event.dart    # Events
│   └── feature_state.dart    # States
├── domain/
│   └── models.dart           # Domain models
├── repository/
│   ├── i_repository.dart     # Repository interface
│   └── repository.dart       # Implementation
└── presentation/
    ├── screens/
    ├── widgets/
    └── routes/
```

### 4. Dependency Injection

```dart
// Route level
class TaskRoute {
  static Widget builder(BuildContext context) {
    return TaskScreen(
      taskRepository: GetIt.I<ITaskRepository>(),
    );
  }
}

// Screen level
class TaskScreen extends StatelessWidget {
  final ITaskRepository taskRepository;
  
  const TaskScreen({required this.taskRepository});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository),
      child: // ...
    );
  }
}
```

### 5. UI Integration

```dart
// Using BlocBuilder
BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoading) {
      return const CircularProgressIndicator();
    }
    // Handle other states
  },
)

// Dispatching events
context.read<TaskBloc>().add(const LoadTasks());
```

### 6. Error Handling

```dart
Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
  emit(const TaskLoading());
  try {
    final tasks = await _repository.getAll();
    emit(TasksLoaded(tasks));
  } catch (e) {
    emit(TaskError(e.toString()));
  }
}
```

### 7. Testing

```dart
void main() {
  group('TaskBloc', () {
    late TaskBloc bloc;
    late MockTaskRepository repository;

    setUp(() {
      repository = MockTaskRepository();
      bloc = TaskBloc(repository);
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TasksLoaded] when LoadTasks is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadTasks()),
      expect: () => [
        const TaskLoading(),
        isA<TasksLoaded>(),
      ],
    );
  });
}
```

## General Guidelines

### 1. Code Organization
- Keep BLoCs focused and single-purpose
- Split large BLoCs into smaller, more manageable ones
- Use proper abstraction layers (Repository, Services if needed)

### 2. State Management
- Make states immutable
- Use sealed classes for states when possible
- Keep states minimal and focused

### 3. Event Handling
- Keep events simple and clear in purpose
- Use meaningful event names
- Document complex event flows

### 4. Performance
- Avoid unnecessary state emissions
- Use equatable for proper state comparison
- Consider using `distinct()` for state streams

### 5. Documentation
- Document public APIs
- Add comments for complex business logic
- Include usage examples in doc comments

### 6. Testing
- Test all event handlers
- Mock external dependencies
- Test edge cases and error scenarios
- Use `bloc_test` package for BLoC testing

### 7. Best Practices
- Follow the Single Responsibility Principle
- Keep the UI dumb, logic in BLoCs
- Use proper error handling
- Implement proper cleanup in `close()`
- Use constructor injection for dependencies 