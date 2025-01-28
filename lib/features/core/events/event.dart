abstract class Event {
  final String? eventId;

  const Event({this.eventId});

  @override
  String toString() {
    if (eventId != null) {
      return 'eventId: $eventId';
    }
    return '';
  }
} 