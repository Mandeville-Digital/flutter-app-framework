class EventSubscription {
  final void Function() _cancelCallback;

  EventSubscription(this._cancelCallback);

  void cancel() {
    _cancelCallback();
  }
} 