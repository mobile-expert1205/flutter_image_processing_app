import 'package:wordfinderx/src/models/custom_keyboard_event.dart';
import 'package:wordfinderx/src/widgets/filtered_input_field/filtered_input_field.dart';

mixin FilteredInputFieldMixin {
  TextValue processKeyboardEvent(TextValue value, CustomKeyboardEvent event) {
    final int statePos = value.cursorPosition;
    final String stateTextValue = value.text;

    final int pos =
        statePos < stateTextValue.length ? statePos : stateTextValue.length;

    if (event.eventType == CustomKeyboardEventType.symbol) {
      List<String> split = splitString(stateTextValue, pos);
      final String resultString = split[0] + event.payload + split[1];
      return TextValue(text: resultString, cursorPosition: pos + 1);
    } else if (pos > 0 &&
        event.eventType == CustomKeyboardEventType.backspace) {
      List<String> split = splitString(stateTextValue, pos);

      final String resultString = split[0].substring(0, pos - 1) + split[1];
      return TextValue(text: resultString, cursorPosition: pos - 1);
    }
    return value;
  }

  List<String> splitString(String originString, int pos) {
    String beginString;
    String endString;
    if (pos == 0) {
      beginString = '';
      endString = originString;
    } else if (pos < originString.length) {
      beginString = originString.substring(0, pos);
      endString = originString.substring(pos);
    } else {
      beginString = originString;
      endString = '';
    }
    return [beginString, endString];
  }

  /// Calculates question mark in string.
  int getQuestionMarkCount(String str) {
    final RegExp regExp = RegExp(r'\?');
    return regExp.allMatches(str).length;
  }
}
