import 'package:flutter/material.dart';

typedef KeyboardWidgetBuilder = Widget Function();

typedef KeyboardLettersRowBuilder = Widget Function(
  List<String> letters, {
  List<Widget> suffix,
});

abstract class CustomKeyboardBuilder {
  Widget build({
    required KeyboardWidgetBuilder footer,
    required KeyboardWidgetBuilder backspaceButton,
    required KeyboardWidgetBuilder lastRow,
    required KeyboardWidgetBuilder bottom,
    required KeyboardLettersRowBuilder lettersRowBuilder,
    required double width,
    required double height,
  });
}
