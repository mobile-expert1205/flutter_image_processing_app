import 'package:flutter/material.dart';
import 'package:wordfinderx/src/common/app_colors.dart';

import 'custom_keyboard_builder.dart';

class CustomLengthKeyboardBuilder extends CustomKeyboardBuilder {
  static const List<String> _firstRowLetters = [
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  static const List<String> _secondRowLetters = [
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
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
              Expanded(
                child: Container(
                  color: AppColors.mediumGreyColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: lettersRowBuilder(_firstRowLetters)),
                      Expanded(
                        child: lettersRowBuilder(
                          _secondRowLetters,
                          suffix: [backspaceButton()],
                        ),
                      ),
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
