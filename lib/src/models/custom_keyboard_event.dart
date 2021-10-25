enum CustomKeyboardEventType {
  symbol,
  backspace,
  submit,
  clear,
}

class CustomKeyboardEvent {
  final CustomKeyboardEventType eventType;
  final String payload;

  const CustomKeyboardEvent({required this.eventType, required this.payload});

  const CustomKeyboardEvent.submit()
      : eventType = CustomKeyboardEventType.submit,
        payload = '';

  const CustomKeyboardEvent.backspace()
      : eventType = CustomKeyboardEventType.backspace,
        payload = '';

  const CustomKeyboardEvent.symbol(String symbol)
      : eventType = CustomKeyboardEventType.symbol,
        payload = symbol;

  const CustomKeyboardEvent.clear()
      : eventType = CustomKeyboardEventType.clear,
        payload = '';

  @override
  String toString() {
    return 'CustomKeyboardEvent{eventType: $eventType, payload: $payload}';
  }
}
