import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

import 'custom_keyboard_builder.dart';

class CustomLetterKeyboardBuilder extends CustomKeyboardBuilder {
  static const List<String> _firstRowLetters = [
    'Q',
    'W',
    'E',
    'R',
    'T',
    'Y',
    'U',
    'I',
    'O',
    'P'
  ];

  static const List<String> _secondRowLetters = [
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
  ];

  static const List<String> _thirdRowLetters = [
    'Z',
    'X',
    'C',
    'V',
    'B',
    'N',
    'M',
  ];

  @override
  Widget build({
    required KeyboardWidgetBuilder footer,
    required KeyboardWidgetBuilder backspaceButton,
    required KeyboardWidgetBuilder lastRow,
    required KeyboardWidgetBuilder bottom,
    required KeyboardLettersRowBuilder lettersRowBuilder,
    required double width,
    required double height,
  }) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: width,
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              footer(),
              Expanded(
                child: Container(
                  color: AppColors.mediumGreyColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: lettersRowBuilder(_firstRowLetters)),
                      Expanded(child: lettersRowBuilder(_secondRowLetters)),
                      Expanded(
                          child: lettersRowBuilder(
                        _thirdRowLetters,
                        suffix: [backspaceButton()],
                      )),
                      Expanded(child: lastRow())
                    ],
                  ),
                ),
              ),
              bottom(),
            ],
          ),
        ),
      ],
    );
  }
}
