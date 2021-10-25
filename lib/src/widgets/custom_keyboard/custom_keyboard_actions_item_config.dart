import 'package:flutter/material.dart';
import 'package:wordfinderx/src/models/custom_keyboard_event.dart';

class CustomKeyboardActionsItemConfig {
  final FocusNode focusNode = FocusNode();

  final ValueNotifier<CustomKeyboardEvent> valueNotifier =
      ValueNotifier(CustomKeyboardEvent.symbol(''));

  void dispose() {
    focusNode.dispose();
    valueNotifier.dispose();
  }
}
