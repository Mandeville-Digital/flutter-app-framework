import 'event.dart';
import 'event_subscription.dart';
import 'event_broker.dart' as broker;

abstract class EventHandler<T extends Event> {
  final broker.EventBroker _eventBroker;
  final List<EventSubscription> _subscriptions = [];

  EventHandler(this._eventBroker) {
    _subscriptions.add(_eventBroker.subscribe<T>(handle));
  }

  void handle(T event);

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
} 