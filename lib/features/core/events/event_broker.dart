import 'dart:async';
import 'event.dart';
import 'event_subscription.dart';

class EventBroker {
  final _controllers = <Type, StreamController<dynamic>>{};
  final _subscriptions = <StreamSubscription<dynamic>>[];

  void publish<T extends Event>(T event) {
    final controller = _controllers[T];
    if (controller != null) {
      controller.add(event);
    }
  }

  EventSubscription subscribe<T extends Event>(void Function(T event) handler) {
    final controller = _controllers.putIfAbsent(
      T,
      () => StreamController<T>.broadcast(),
    ) as StreamController<T>;

    final subscription = controller.stream.listen(handler);
    _subscriptions.add(subscription);

    return EventSubscription(() {
      subscription.cancel();
      _subscriptions.remove(subscription);
      
      if (!controller.hasListener) {
        controller.close();
        _controllers.remove(T);
      }
    });
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
} 