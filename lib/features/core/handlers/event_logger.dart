import 'package:logger/logger.dart';
import '../events/event.dart';
import '../events/event_broker.dart' as broker;
import '../events/event_handler.dart';

class EventLogger extends EventHandler<Event> {
  final Logger _logger;

  EventLogger(broker.EventBroker eventBroker, this._logger) : super(eventBroker);
  
  @override
  void handle(Event event) {
    final timestamp = DateTime.now().toIso8601String();
    final eventName = event.runtimeType.toString();
    
    final readableName = eventName
        .replaceAllMapped(RegExp(r'([A-Z])', ), (match) => ' ${match.group(1)}')
        .trim()
        .replaceAll('Event', '')
        .trim();
    
    _logger.i('[$timestamp] $readableName');

    final eventProps = event.toString()
        .replaceAll(RegExp(r'^Instance of .+\('), '')
        .replaceAll(')', '');
    
    if (eventProps.isNotEmpty) {
      _logger.d('  Details: $eventProps');
    }
  }
} 